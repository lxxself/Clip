---
id: 7c5b9e52-c301-4bdd-8e29-58a4b8421299
---

# APK瘦身属性——android:extractNativeLibs - bjxiaxueliang - 博客园
#Omnivore

[Read on Omnivore](https://omnivore.app/me/apk-android-extract-native-libs-bjxiaxueliang-18b0e9cee7b)
[Read Original](https://www.cnblogs.com/xiaxveliang/p/14583802.html)

先描述一下结论：

`android:extractNativeLibs = true`时，gradle打包时会`对工程中的so库进行压缩`，最终生成`apk包的体积会减小`。  
但用户在手机端进行apk安装时，系统会对压缩后的so库进行解压，从而造成用户`安装apk的时间变长`。

关于`android:extractNativeLibs`默认值设定方面，若开发人员未对android:extractNativeLibs进行特殊配置：

* `minSdkVersion < 23 或 Android Gradle plugin < 3.6.0`情况下，打包时 `android:extractNativeLibs=true`；
* `minSdkVersion >= 23 并且 Android Gradle plugin >= 3.6.0`情况下，打包时`android:extractNativeLibs=false`；

## 一、起因

偶然发现，使用AndroidStudio将同一Module分别打包为`aar`与`apk`，两者占用的磁盘空间差距巨大：  
`打包为aar，占用磁盘空间4.4M；打包为apk，占用磁盘空间为11.7M；`

使用AndroidStudio中 [apkanalyzer](https://developer.android.com/studio/command-line/apkanalyzer) 对比分析，两种打包方式so库 `Rwa File Size` 差距较大，但两者的`Download Size` 大小完全一致：  
`打包为aar，so库Rwa File Size为3.4M；打包为apk，so库Rwa File Size为8.2M；`  
`打包为aar，so库Download Size为3.3M；打包为apk，so库Download Size为3.3M；`

两种打包方式 [apkanalyzer](https://developer.android.com/studio/command-line/apkanalyzer) 对比分析如下：

![打包为aar](https://proxy-prod.omnivore-image-cache.app/0x0,s54SIv2t4TXN8RtF5NVF9kdrWdcjB-Yty4nwhdGDYcFw/https://img-blog.csdnimg.cn/img_convert/93489aaad89cc7bcd2b174e8407c16b8.png)

![打包为apk](https://proxy-prod.omnivore-image-cache.app/0x0,sT7p2JcoJ3dlP31KNidkvgoMNLRtueETlUskmTUWNThM/https://img-blog.csdnimg.cn/img_convert/e1178f15b4215af3dd0cb6bb4905e2ef.png)

两种打包方式`Rwa File Size` 与`Download Size` 差距较大，那`Raw File Size`与`Download Size`又是如何定义的呢？

## 二、Raw File Size & Download Size

官方 [view\_file\_and\_size\_information：](https://developer.android.com/studio/build/apk-analyzer.html#view%5Ffile%5Fand%5Fsize%5Finformation) 描述如下：

`APK Analyzer shows raw file size and download file size values for each entity, as shown in figure 1. Raw File Size represents the unzipped size of the entity on disk while Download Size represents the estimated compressed size of the entity as it would be delivered by Google Play. The % of Total Download Size indicates the percentage of the APK's total download size the entity represents.`

翻译后：

APK Analyzer 展示每个实体的 `Raw File Size` 与`download file size` ：  
`Raw File Size` 代表对应实体在磁盘上未进行压缩的大小；  
`Download Size` 代表对应实体在Google Play中，预估的压缩后的大小；  
`% of Total Download Size` 代表对应模块实体，在Download Size总大小中所占百分比。

![View file and size information](https://proxy-prod.omnivore-image-cache.app/0x0,sFkpahIVJyjoQD3h_uIHQtAOS_z898lVYg6I53wgy4VM/https://img-blog.csdnimg.cn/img_convert/680ad0ef8fb253a51244f01ac33344a0.png)

#### 看到这里，怀疑：

`打包为aar时，AndroidStudio对Module中的so库进行了压缩；但打包为apk时，未对Module中的so库进行压缩`。

查询相关资料，发现文章[Android APK Raw File Size vs Download Size：](https://stackoverflow.com/questions/45024723/android-apk-raw-file-size-vs-download-size-how-to-shrink-the-raw-file-size)  
文章中提到：  
打包APK时，`是否对so库进行压缩`的控制属性为 `android:extractNativeLibs`。

![Android APK Raw File Size vs Download Size](https://proxy-prod.omnivore-image-cache.app/0x0,sG2MDacFsIHdNWbiNWblsgmyyvMf03tpnkwwl7-oEIS0/https://img-blog.csdnimg.cn/img_convert/48547769ef1eab921ffbd5b8b2be1c6c.png)

`AndroidManifest.xml`中`extractNativeLibs`属性使用方式：

```applescript
<application
    android:extractNativeLibs="true">
</application>

```

### 3.1、android:extractNativeLibs = true

若`android:extractNativeLibs = true`，进行apk打包时，`AndroidStudio会对Module中的so库进行压缩`，最终得到的apk体积较小。

* `好处是：`用户在应用市场下载和升级时，因为消耗的流量较小，用户有更强的下载和升级意愿。
* `缺点是：`因为so是压缩存储的，因此用户安装时，系统会将so解压出来，重新存储一份。因此安装时间会变长，占用的用户磁盘存储空间反而会增大。

### 3.2、android:extractNativeLibs = false

若`android:extractNativeLibs = false`，进行apk打包时，`AndroidStudio不会对Module中的so库进行压缩`，最终生成的apk体积较大。

* `好处是：`用户安装后，直接使用`/data/data/your.app.package/lib`路径下的so，没有额外的so复制操作，相对于`android:extractNativeLibs = true`而言，节省用户磁盘存储空间；

### 3.3、结论

`android:extractNativeLibs = true的设定还是利大于弊的。`

`设置为true可以工程中的so库进行压缩，最终减小生成的apk包大小。至于安装应用时，因so库解压缩而造成的安装时间增长，相对于带来的好处（提高应用市场用户的下载和升级意愿）而言，我认为是可接受的。`

## 四、android:extractNativeLibs默认值

[android:extractNativeLibs官方API描述如下：](https://developer.android.com/guide/topics/manifest/application-element.html#extractNativeLibs)

![android:extractNativeLibs官方API描述](https://proxy-prod.omnivore-image-cache.app/0x0,sCdkWx1hbRN_dPJeCiTG4pXznOGEfXmAovbCq53W48xU/https://img-blog.csdnimg.cn/img_convert/2d8b409d13ef726a587d69e4b2b66a07.png)

从android:extractNativeLibs官方API描述中可以了解到：

* 源码中 android:extractNativeLibs默认值为true；
* 编译器Android Gradle plugin 3.6.0 或更高版本，android:extractNativeLibs默认值为false；

`但真的是这样吗？一起来探究一下。`

从Android 6.0（API 23）开始，Android frame源码中`PackageParser.java`在读取`android:extractNativeLibs`属性值时，默认值为true；

对应的源码路径：`frameworks/base/core/java/android/content/pm/PackageParser.java`

```angelscript
if (sa.getBoolean(
        com.android.internal.R.styleable.AndroidManifestApplication_extractNativeLibs,
        true)) {
    ai.flags |= ApplicationInfo.FLAG_EXTRACT_NATIVE_LIBS;
}

```

### 4.2、Android Gradle plugin 3.6.0 或更高版本

编译器`Android Gradle plugin 3.6.0 或更高版本`，在构建应用时会默认将 `extractNativeLibs 设置为 false`。

通过观察编译后生成的`AndroidManifest.xml`文件，发现 gradle 插件设置默认值为false，是通过在处理AndroidManifest.xml文件的时，`在其中自动插入 android:extractNativeLibs=“false"来实现的`。  
由于 `android:extractNativeLibs` 这个属性是在Android 6.0（API 23）引入的，因此如果项目配置 中`minSdkVersion < 23` 的话，gradle 插件不会自动插入`android:extractNativeLibs=“false"`。

### 4.3、结论

开发人员在进行apk打包时，若未对android:extractNativeLibs进行特殊配置：

* 若 `minSdkVersion < 23 或 Android Gradle plugin < 3.6.0`，打包时 `android:extractNativeLibs=true`；
* 若`minSdkVersion >= 23 并且 Android Gradle plugin >= 3.6.0`，打包时`android:extractNativeLibs=false`；

## 五、参考

[apkanalyzer：](https://developer.android.com/studio/command-line/apkanalyzer)  
<https://developer.android.com/studio/command-line/apkanalyzer>

[view\_file\_and\_size\_information：](https://developer.android.com/studio/build/apk-analyzer.html#view%5Ffile%5Fand%5Fsize%5Finformation)  
<https://developer.android.com/studio/build/apk-analyzer.html#view%5Ffile%5Fand%5Fsize%5Finformation>

[Android APK Raw File Size vs Download Size：](https://stackoverflow.com/questions/45024723/android-apk-raw-file-size-vs-download-size-how-to-shrink-the-raw-file-size)  
<https://stackoverflow.com/questions/45024723/android-apk-raw-file-size-vs-download-size-how-to-shrink-the-raw-file-size>

[android:extractNativeLibs：](https://developer.android.com/guide/topics/manifest/application-element.html#extractNativeLibs)  
<https://developer.android.com/guide/topics/manifest/application-element.html#extractNativeLibs>

[Setting android:extractNativeLibs to reduce app size：](https://stackoverflow.com/questions/42998083/setting-androidextractnativelibs-false-to-reduce-app-size)  
<https://stackoverflow.com/questions/42998083/setting-androidextractnativelibs-false-to-reduce-app-size>

## \========== THE END ==========

![欢迎关注我的公众号](https://proxy-prod.omnivore-image-cache.app/0x0,stJ-afyvQnGfU2mthtAgjmiEv1BpV0YCkeKRFuB7j_CA/https://img-blog.csdnimg.cn/img_convert/1c3c957f194c08fbc8dd89c6843e6f2f.png)

posted @ [bjxiaxueliang](https://www.cnblogs.com/xiaxveliang/)阅读(8951) 评论() [编辑](https://i.cnblogs.com/EditPosts.aspx?postid=14583802)收藏 举报

---

