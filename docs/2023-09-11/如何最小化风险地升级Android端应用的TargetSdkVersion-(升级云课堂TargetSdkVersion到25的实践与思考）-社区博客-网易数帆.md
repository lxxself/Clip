---
id: c7b07c30-324e-4bc6-a8e7-7df7732e2863
---

# 如何最小化风险地升级Android端应用的TargetSdkVersion?(升级云课堂TargetSdkVersion到25的实践与思考）-社区博客-网易数帆
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-target-sdk-version-target-sdk-version-25-18a8341e0da)
[Read Original](https://sq.sf.163.com/blog/article/175733451592228864)

## 问题背景

云课堂之前的TargetSdk是19，而现在Android系统已经出到了26，市面上Android各个版本的占比如下图：

| Version     | Codename          | API | Distribution |
| ----------- | ----------------- | --- | ------------ |
| 2.3.3-2.3.7 | Gingerbread       | 10  | 0.5%         |
| 4.0.3-4.0.4 | IceCream Sandwich | 15  | 0.5%         |
| 4.1.x       | Jelly Bean        | 16  | 2.2%         |
| 4.2.x       | Jelly Bean        | 17  | 3.1%         |
| 4.3         | Jelly Bean        | 18  | 0.9%         |
| 4.4         | KitKat            | 19  | 13.8%        |
| 5.0         | Lollipop          | 21  | 6.4%         |
| 5.1         | Lollipop          | 22  | 20.8%        |
| 6.0         | Marshmallow       | 23  | 30.9%        |
| 7.0         | Nougat            | 24  | 17.6%        |
| 7.1         | Nougat            | 25  | 3.0%         |
| 8.0         | Oreo              | 26  | 0.3%         |

根据2017.11月的统计数据显示，目前在使用的安卓手机中，Android5.0以上的份额占了79%，**对于这部分用户，他们在使用云课堂的时候，没法体验新版本系统的特性**，例如运行时权限，以及新版系统对应用在视觉及性能做出的优化等等。而对于开发来说，我们也可以使用最前沿的技术，**在谷歌每次升级系统的时候，我们也能够更快的适配上去**，让用户第一时间体验新版本下的云课堂。所以，升级应用的TargetSdk是有必要的。

## 问题分析

分析之前，我们先简单说明一下几个概念，什么是**compileSdkVersion**，**minSdkVersion**以及**targetSdkVersion**。

* complieSdkVersion。告知Gradle应该用什么版本去编译你的App，当我们设置了比较新的版本，我们就能够用到最新的APIs；改变编译版本并不会改变运行时的行为。
* minSdkVersion。应用运行的最低要求；它是谷歌商店用来判断用户设备是否可以安装某个应用的标志之一；在开发时，lint会在项目中运行，它在使用了高于minSdkVersion的API时会警告你，帮你避免调用了不存在的API的运行时问题。
* targetSdkVersion。它是Android提供向前兼容的主要依据，就是在应用的targetSdkVersion没有更新之前系统不会应用最新的行为变化。

对于compileSdkVersion，我们应该总是使用最新的SDK进行编译，避免使用新弃用的API，并且为使用新的API做好准备。

对于minSdkVersion，除非某些库的minSdkVersion变了，或者核心代码中必须使用更新的API，我们才改变它的值。

对于targetSdkVersion，我们需要注意代码是否适应更新后的版本号，要进行全面的测试，要针对谷歌发布的每个新版本里的行为变化进行处理。

对于云课堂App来说，之前的TargetSdkVersion是19，现在要升到25，这中间跨越了多个版本，因此首先要知晓每个版本的行为更变。这里举个例子，对于运行时动态权限，之前我们都是在清单文件中写明需要的权限，应用安装好，自动拥有。而6.0系统以上，需要代码去申请，最重要的是，用户还可以拒绝。比如读写磁盘权限，一旦拒绝了，对于之前的不够健壮的代码，功能失效且不说，时常会冒出一个空指针奔溃，或者UnsecurityException等等。

另外教育产品部，有多个多产品，共用一些通用的模块，因此这次改动会涉及到所有的产品线，并且最终要确保都能无感知的升级TargetSDkVersion。

风险是巨大的，任务是艰巨的，但总得往前走。

## 方案设计

### 在进行设计方案之前，我们先看看几个主要的注意事项（详细的请参见参考文献），如下：

* **运行时权限**。在Android6.0以后，对权限进行了分组：正常权限，和运行时权限。原来写在清单文件的部分权限，需要在使用时才申请。如果未获得权限，则会抛出异常。
* 在某些场景会抛出**FileUriExposedExceptionAndroid**。在7.0框架上强制执行了StrictMode API政策，禁止向你的应用外公开`file://URI`。如果一项包含文件的file://uri类型的Intent离开你的应用，应用将抛出FileUriExposedException异常。**会影响调用系统相机拍照，裁切照片，应用内下载apk安装应用。**

### 有如下几个方面需要设计：

* 在知晓每个版本升级的行为变更后，考虑到**每个模块都需要检查代码**，比如它是否访问了File，是否有打开相机、相册、麦克风，是否有读写外置SDcard磁盘操作等等。 我们考虑使用Android 自定义lint检查。
* **动态权限申请**。需要一套动态权限的工具，它应该能够非常灵活，在调用需要权限的方法前，增加权限判断，有权限则执行，无权限则不执行，然后弹出权限申请框，在获取权限之后又能继续执行。在多方调研后，我们使用了_PermissionsDispatcher_库，在需要权限的方法上添加注解。
* 有很多地方需要使用**provider**，因此在framework层提供一个FileProvider，统一管理需要向外暴露file://URI类型的Intent。

## 升级TargetSdk实践

下面一一讲解：

#### （一）Android可使用的文件路径

虽然有一条读写磁盘的权限是动态权限，但是Android在5.0之后，给了App开发者**几个不需要权限就可以读写的文件路径**。因此，App其实可以不需要读写磁盘的权限，除非是一些第三方库需要，或者应用本身有着特殊路径的要求。 这里先来了解下android可使用的文件路径。

首先，App在手机上保存文件或者缓存数据时，应该遵守以下几点：

* 不要随意占用用户的内置存储
* 不要随意在SD卡上新建目录，应该防止在应用包名对应下的扩展存储目录下，卸载App时可以自动被清除
* 对占用的 磁盘空间有上限，并按照一定的策略进行清除

Android下有哪些文件目录：

**1、应用私有存储（内置存储）**

这里可以用来保存不能公开给其他应用的一些敏感数据如个人信息 `Context.getFileDir() //对应路径/data/data/应用包名/files/`

这里可以保存一些缓存文件如图片，当内置存储的空间不足时系统自动清除 `Context.getCacheDir()//对应路径/data/data/应用包名/cache/`

权限：**不需要权限申请**

以上是手机的内置存储，没有root过的手机是无法用文件管理器之类的工具查看的，而且这些数据也会随着用户卸载App而被一起删除。这两个目录其实就对应着设置->应用->你的App->存储空间下面的清除数据和清楚缓存。

**2、应用扩展存储（SD卡）**

对应路径是：

`Context.getExternalFilesDir() //SDCard/Android/data/应用包名/files/` `Context.getExternalCacheDir() //SDCard/Android/data/应用包名/cache/`

权限： API<19，需要在清单文件写明权限 API>=19，不需要权限

既然是SD卡上的目录，那么是可以被其他的应用读取到的，所以这个目录下，不应该存放用户的敏感信息。同上面一样的，这里的文件会随着App卸载而被删除，也可以由用户手动在设置界面里面清除。

#### （二）Android Lint 自定义

Android Lint是谷歌提供给Android开发者的静态代码检查工具。使用Lint对Android工程代码进行扫描和检查，可以发现代码潜在的问题，提醒开发及早修正。

当我们确定了调用了某些需要权限的代码的关键词时，我们可以通过自定义Lint检查器，在需要检查的模块的build.gradle加上自定义Lint检查的依赖。然后便可以通过执行Lint检查，检查结果会告知我们哪些地方出现了警告亦或错误。

当我们写好一套针对升级TargetSdkVersion的自定义lint检查，不仅能用在这次的任务中，还能够为以后开发新功能的开发人员进行提醒，以便开发人员都能意识到新的代码需要权限等安全问题。

代码中会出现明显的黄色的编译警告提示，如果我们定义了某种ISSUE为ERROR级别，那么会出现红色下划线。

![](https://proxy-prod.omnivore-image-cache.app/0x0,slk5rECmEqHX858tlKyuJ8T8gWtpgnu2tBZl054RRdAc/https://nos.netease.com/cloud-website-bucket/20180712134605a5b560f5-07ca-4e35-a209-56c19d9d5f7a.png)

这是这个模块的所有的Lint检查结果。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sQrUd2dorZAhEkRge8OGeSou_SiVHJJEFNKpBvc6grJ0/https://nos.netease.com/cloud-website-bucket/2018071213461412a593b8-c356-473a-b6be-b0e17a82e9cf.png)

编写自定义lint可见参考文献。 大致以下几个步骤。

* 需要一个java工程，负责编写Lint检查的Detector
* 需要一个lib模块，负责引入（1）生成的jar包，将自己模块创建成aar形式
* 需要进行Lint检查的模块，依赖上（2）模块

#### （三）Android 权限管理

**1、明确哪些权限是需要动态申请的** 我们可以查看下所有的权限[官方文档](https://developer.android.com/guide/topics/permissions/normal-permissions.html)，这里只列一下需要动态申请的。

![](https://proxy-prod.omnivore-image-cache.app/0x0,shyF1k6NBcOlP8ctgObwdfuz-Jgc0MBukic12tFxQzOs/https://nos.netease.com/cloud-website-bucket/2018071213462835be37b7-8ec2-4641-a630-ae558409c10b.png)

这里需要知道的是权限和权限组的关系，当我们获取某个权限的时候，自动就能获取这个权限组的其他相关权限。

**2、明确哪些权限是应用需要的**

以云课堂为例，我们可以通过查看当前应用的信息，获知当前应用所需要的权限。如图，

![](https://proxy-prod.omnivore-image-cache.app/0x0,sH91NnZMSU5JJZkpNfdr1Sx0mkfpRZEBDebbii3ur-GY/https://nos.netease.com/cloud-website-bucket/20180712134643cee364c4-6a86-475c-81bf-9418069a27bc.png)

以上这些表示写在清单文件中，并且用户有权利关闭的权限。

**3、明确使用权限的时候会有哪些关键词操作**

比如打开相机，一般的操作都是

```reasonml
Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
...
intent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
startActivityForResult(intent, requestCode);

```

再比如访问外置SDCard，

```reasonml
Environment.getExternalStorage()

```

再比如访问设备IMEI信息等，都需要先获取TelephoneManager类，

```ebnf
TelephonyManager mTelephonyMgr = (TelephonyManager)
context.getSystemService(Context.TELEPHONY_SERVICE);

```

等等。在得知这些关键词之后，我们就可以通过自定义Lint进行代码扫描，在找到这些地方后，在对应页面，使用_PermissionsDispatcher库_注解的方式，对需要权限的方法进行注解。

该第三方动态权限库有以下几个注解：

* **@RuntimePermissions** 必须在Activity或Fragment类上添加，才能让编译的时候生成对应的XXXActivity权限辅助类。
* **@NeedsPermission** 必须在需要权限的非私有方法上加上这个注解
* **@OnShowRationale** 如果在某个方法上加了这个注解，第一次申请拒绝后，第二次申请会回调这个方法，注意：该方法必须是这样的签名(PermissionRequest request)
* **@OnPermissionDenied** 在拒绝权限后，会回调这个方法
* **@OnNeverAskAgain** 当第一次申请拒绝后，且第二次申请勾选了不在询问选项后，回调这个方法

需要在调用需要权限方法的地方，改用使用XXXPermissionDispatcher类的checkXXX方法。 需要重写onRequestPermissionResult方法，调用XXXPermissionDispatcher类同名方法。

增加注解后的方法调用逻辑整理如下：

![](https://proxy-prod.omnivore-image-cache.app/0x0,saJcDI7sCw9MhxPLOqHrqTUFsPOJRil3hIpO8XAb7wvw/https://nos.netease.com/cloud-website-bucket/201807121347012fb69a35-e61f-4586-ba71-f946ec8c58f3.png)

#### （四）全局的FileProvider

拍照或者在应用内使用应用安装器，都需要传递file://URI给外部应用。这里需要提供一个FileProvider，它是ContentProvider的子类，它使用了和内容提供器类似的机制来对数据进行保护，可以选择性地将封装过的Uri共享给外部，从而提高了应用的安全性。

首先，在清单文件中，注册这个provider，考虑到这个FileProvider会在多个模块中用到，因此我们将它放在了framework层，**这里要注意authorities，每个应用都应该不一样，否则在这些应用无法在手机上共存！**

```dust
//AndroidManifest.xml中
    <provider
        android:name="android.support.v4.content.FileProvider"
        android:authorities="${applicationId}.fileprovider"
        android:grantUriPermissions="true"
        android:exported="false">
        <meta-data
            android:name="android.support.FILE_PROVIDER_PATHS"
            android:resource="@xml/edu_android_framework_filepath" />
    </provider>

// res/xml配置
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <!--Android 7.0 直接使用本地真实路径被认为是不安全的，会抛出FileUriExposedExCeption异常-->
    <external-files-path name="external_file_dir" path=""  />
    <external-cache-path name="external_cache_dir" path="" />
    <files-path name="file_dir" path="" />
    <cache-path name="cache_dir" path="" />
</paths>

```

这里要注意的是做好版本兼容，否则适配了7.0，结果4.4以下的手机却不能用了。

```reasonml
//适配拍照功能
public static void adapterIntentForCamera(Context context, Intent intent, File imageTempFile) {
        if (intent == null || imageTempFile == null) {
            return;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {//android 5.0 以上
            Uri imageUri = FileProvider.getUriForFile(context, FileProviderUtil.FILE_AUTHORITY, imageTempFile);
            intent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
        } else {
            Uri imageUri = Uri.fromFile(imageTempFile);
            intent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
        }
    }

```

同理，应用安装也要做好版本适配。

```reasonml
    /**
     * 安装APK
     * @param context 可以传Application Context 或者 Activity
     * @param authority 建议传入 FileProviderUtil.FILE_AUTHORITY
     */
    public static boolean installApk(Context context, String authority, File file) {
        if (file == null) return false;
        if (!file.exists()) return false;
        NTLog.d(TAG, "installApk " + file.toString());

        try {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            Uri data;
            // 判断版本大于等于7.0
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                // 给目标应用一个临时授权
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                // 即是在清单文件中配置的authorities
                data = FileProvider.getUriForFile(context, authority, file);
            } else {
                data = Uri.fromFile(file);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            }
            intent.setDataAndType(data, "application/vnd.android.package-archive");
            context.startActivity(intent);
        } catch (Exception e) {
            NTLog.e(TAG, e.getMessage());
            return false;
        }
        return true;
    }

```

## 其他的一些坑

* 从Android5.0开始，**WebView默认不支持同时加载Https和Http混合模式**，需要代码手动配置。
* 原本以为将所有读写文件的地方都改到不需要权限的路径下，就可以不需要`WRITE_EXTERNAL_STORAGE`权限，结果云课堂之前的文件下载路径都是自定义外置存储卡路径，这里需要兼容之前用户的。
* 同理，一些第三方库，它们在初始化的时候，并未提供对诸如日志、缓存等文件的自定义文件路径配置。它们可能并未对6.0做对应的适配。这将导致轻则log日志丢失，重则功能失效的问题。需要我们开发人员与依赖的第三方库的开发人员进行相应的沟通，寻找最好的解决办法。

## 总结及思考

* 总的来说，在开始任务前，应该做好充分的调研，比如应该明确这次升级TargetSdkVersion会带来哪些风险，哪些改动，然后再进行方案的设计。而不是盲目的等待问题的出现，在进行修修补补。
* 再者，在修改每处代码，都应该记录下来，例如个人用户设置模块，扫二维码模块，安装应用更新包等等。在后期，和各个产品线的测试人员沟通的时候，就会轻松很多，应该给他们列出所有需要回归的地方。自己改的放心，测试测的放心，上线也会有更大的质量保障。
* 另外，在明确方案后，修改代码之前，还需要和各个产品端的策划沟通，让他们知晓你的改动方案，并接受这样的交互方式，不然到头来，苦的是自己。
* 最后，在调研、设计、修改的过程中，及时进行文档记录，最后输出一篇技术文档，能让组里其他的开发人员知晓这项改动，并在以后的开发中，面对同样的问题，有文档可参考。

这项任务，虽然没有包含什么业务需求，但是对于产品发展来说，确实必不可少的，谷歌最近刚推出了Android O 也就是 Android 26。如果我们仍旧保持原来的target版本，越到后面，升级面临的风险越大。等到谷歌推动我们改的时候，我们已经病入膏肓了，显得太被动。所以我们应该及时的更新应用的target版本，保持着比较新的代码，好的产品是坚实的基础技术服务所支持的，所以我们也应该**推动类似这样的技术优化服务，不要畏惧风险**。

## 参考文章

* [Picking your compileSdkVersion, minSdkVersion, and targetSdkVersion](https://medium.com/google-developers/picking-your-compilesdkversion-minsdkversion-targetsdkversion-a098a0341ebd)
* [VERSION\_CODES升级带来的行为变化文档](https://developer.android.com/reference/android/os/Build.VERSION%5FCODES.html?utm%5Fcampaign=adp%5Fseries%5Fsdkversion%5F010616&utm%5Fsource=medium&utm%5Fmedium=blog)
* [API平台亮点](https://developer.android.com/guide/topics/manifest/uses-sdk-element.html?utm%5Fcampaign=adp%5Fseries%5Fsdkversion%5F010616&utm%5Fsource=medium&utm%5Fmedium=blog#ApiLevels)
* [动态权限注解处理库](https://github.com/permissions-dispatcher/PermissionsDispatcher)
* [权限适配之SD卡写入](http://unclechen.github.io/2016/03/06/Android6.0%E6%9D%83%E9%99%90%E9%80%82%E9%85%8D%E4%B9%8BSD%E5%8D%A1%E5%86%99%E5%85%A5)
* [自定义Lint（一）](https://segmentfault.com/a/1190000006258386)
* [自定义Lint（二）](https://segmentfault.com/a/1190000006258533)

本文来自网易实践者社区，经作者陈柏宁 授权发布。

## ![](https://proxy-prod.omnivore-image-cache.app/0x0,sCWqhS9KIQNsTdyPIiHFeb-0XhmOnzXbCcPzrw3mB4Nw/https://sq.sf.163.com/assets/img/cms/icon_rmbk.png)推荐博客

* [libvirt打包小结](https://sq.sf.163.com/blog/article/187645794019196928)
* [基于Spark的大规模语言模型训练(下篇)](https://sq.sf.163.com/blog/article/190216358879055872)
* [ceilometer命令行使用方法（上篇）](https://sq.sf.163.com/blog/article/190900988070350848)
* [浙江省CIO协会钱塘江论坛近日在网易云创沙龙宣布成立](https://sq.sf.163.com/blog/article/201481374001598464)
* [消息中间件客户端消费控制实践](https://sq.sf.163.com/blog/article/208767166949027840)
* [云计算解决方案 ](https://sq.sf.163.com/blog/article/220623632093384704)
* [打造业界最牛微服务，网易云这两位“大神”获了大奖](https://sq.sf.163.com/blog/article/244277326509412352)
* [【解构云原生】基于Filebeat的日志采集服务设计与实践](https://sq.sf.163.com/blog/article/370289929463521280)
* [度量字段和维度字段在有数的含义](https://sq.sf.163.com/blog/article/452198962887041024)

---

