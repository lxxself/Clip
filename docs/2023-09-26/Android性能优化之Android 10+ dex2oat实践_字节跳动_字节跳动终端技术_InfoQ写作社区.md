---
id: 930e263f-f70f-425d-9bf0-cd07d917b2ba
---

# Android性能优化之Android 10+ dex2oat实践_字节跳动_字节跳动终端技术_InfoQ写作社区
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-android-10-dex-2-oat-info-q-18ad028b295)
[Read Original](https://xie.infoq.cn/article/2dd9ce05a4013d21999a342c9)

![Android性能优化之Android 10+ dex2oat实践](https://proxy-prod.omnivore-image-cache.app/0x0,sDZeo2Grz74LcvJyU79yVh1iwYr4leBPOb6J3zXNow3c/https://static001.geekbang.org/infoq/ce/ce25de7851e67a95b979ad461a7941c1.jpeg)

作者：字节跳动终端技术——郭海洋

## 背景

对于`Android App`的性能优化来说，方式方法以及工具都有很多，而`dex2oat`作为其中的一员，却可能不被大众所熟知。它是`Android`官方应用于运行时，针对`dex`进行`编译优化`的程序，通过对`dex`进行一系列的指令优化、编译机器码等操作，提升`dex加载速度`和`代码运行速度`，从而提升安装速度、启动速度、以及应用使用过程中的流畅度，最终提升用户日常的使用体验。

它的适用范围也比较广，可以用于`Primary Apk`和`Secondary Apk`的`常规场景`和`插件场景`。（`Primary Apk`是指的`常规场景`下的`主包`（`base.apk`）或者`插件场景`下的`宿主包`，`Secondary Apk`是指的`常规场景`下的`自行加载的包`(`.apk`)或者`插件场景`下的`插件包`(`.apk`)）。

而随着`Android`系统版本的更迭，发现原本可以在`应用进程`上触发`dex2oat`编译的方式，却在`targetSdkVersion>=29`且`Android 10+`的系统上，不再允许使用。其原因是系统在`targetSdkVersion=29`的时候，对此做了限制，不允许`应用进程`上触发`dex2oat`编译（[Android 运行时 (ART) 不再从应用进程调用 dex2oat。这项变更意味着 ART 将仅接受系统生成的 OAT 文件](https://xie.infoq.cn/link?target=https%3A%2F%2Fdeveloper.android.com%2Fabout%2Fversions%2F10%2Fbehavior-changes-10%3Fhl%3Dzh-cn%23system-only-oat)）（`OAT`为`dex2oat`后的产物）。

那当前是否会受到这个限制的影响呢？

在`2020`年的时候`Android 11`系统正式发布，各大应用市场就开始限制`App`的`targetSdkVersion>=29`，而`Android 11`系统距今已经发布一年之久，也就意味着，现如今`App`的`targetSdkVersion>=29`是不可避免的。而且随着新`Android`设备的不断迭代，越来越多的用户，使用上了携带新系统的新机器，使得`Android 10+`系统的占有量逐步增加，目前为止`Android 10+`系统的占有量约占整体的`30%~40%`左右，也就是说这部分机器将会受到这个限制的影响。

那这个限制有什么影响呢？

这个限制的关键是，不允许`应用进程`上触发`dex2oat`编译，换句话说就是并不影响系统自身去触发`dex2oat`编译，那么限制的影响也就是，影响那些需要通过`应用进程`去触发`dex2oat`编译的场景。

对于`Primary Apk`和`Secondary Apk`，它们在`常规场景`和`插件场景`下，系统都会收集其运行时的`热点代码`并用于`dex2oat`进行`编译优化`。此处触发`dex2oat`编译是系统行为，并不受限于上述限制。但触发此处`dex2oat`编译的条件是比较苛刻的，它要求设备必须处于空闲状态且要连接电源，而且其校验的间隔是一天。

在上述条件下，由系统触发的`dex2oat`编译，基本上很难触发，从而导致`dex加载速度`下降`80%`以上，`代码运行速度`下降`11%`以上，使得应用的`ANR`率提升、流畅度下降，最终影响用户的日常使用体验。

对于之前来说改进方案就是通过`应用进程`触发`dex2oat`编译来弥补系统触发`dex2oat`编译的不足，而如今因限制会导致部分机器无法生效。

如何才能让用户体会到`dex2oat`带来的体验提升呢？问题又如何解决呢？

下面通过探索，一步步的逼近真相，解决问题\~

## 探索

探索之前，先明确下核心点，本次探索的目标就是为了让用户体会到`dex2oat`带来的体验提升，其最大的阻碍就是系统触发`dex2oat`的编译条件太苛刻，导致难以触发，之前的成功实践就是基于`App维度`手动触发`dex2oat`编译来弥补系统触发`dex2oat`的编译的不足。

而现在仍需探索的原因就是，原本的成功实践，目前在某些机器上已经受限，为了完成目标，解决掉现有的问题，自然而然的想法就是，限制究竟是什么？限制是如何生效的？是否可以绕过？

## 限制是什么？

目前对于限制的理解，应该仅限于背景中的描述，那`Google官方`是怎么说的呢？

> Android 运行时 (ART) 不再从应用进程调用 `dex2oat`。这项变更意味着 ART 将仅接受系统生成的 OAT 文件。（[Android 运行时只接受系统生成的 OAT 文件](https://xie.infoq.cn/link?target=https%3A%2F%2Fdeveloper.android.com%2Fabout%2Fversions%2F10%2Fbehavior-changes-10%3Fhl%3Dzh-cn%23system-only-oat)）

通过`Google官方`的描述大致可以理解为，原本`ART`会从应用进程调用`dex2oat`，现在不再从应用进程调用`dex2oat`了，从而使得应用进程没有时机触发`dex2oat`，从而达到限制`App维度`触发`dex2oat`的目的。

但问题确实有这么简单嘛？

通过对比`Android 9` 和 `Android 10`的代码时发现，`Android 9`在构建`ClassLoader`的时候会触发`dex2oat`，但是 `Android 10` 上相关代码已经被移除，此处同`Google官方`的说法一致。

但如果限制仅仅如此的话，可以按照原本`ART`从应用进程调用`dex2oat`的方式，然后手动从应用进程调用就可以了。

由于``` Android`` ``10 ```相关代码已经移除，所以查看下`Android 9`的代码，看下之前是如何从应用进程调用`dex2oat`的，相关代码链接：[https://android.googlesource.com/platform/art/+/refs/tags/android-9.0.0\_r52/runtime/oat\_file\_assistant.cc#698](https://xie.infoq.cn/link?target=https%3A%2F%2Fandroid.googlesource.com%2Fplatform%2Fart%2F%2B%2Frefs%2Ftags%2Fandroid-9.0.0%5Fr52%2Fruntime%2Foat%5Ffile%5Fassistant.cc%23698)，通过查看代码可以看出，是通过拼接`dex2oat`的命令来触发执行的，按照如上代码，拼接`dex2oat`命令的伪代码如下：

`//step1 拼接命令` `  
` `List<String> commandAndParams = new ArrayList<>();` `  
` `commandAndParams.add("dex2oat");` `  
` `if (Build.VERSION.SDK_INT >= 24) {` `  
` `    commandAndParams.add("--runtime-arg");` `  
` `    commandAndParams.add("-classpath");` `  
` `    commandAndParams.add("--runtime-arg");` `  
` `    commandAndParams.add("&");` `  
` `}` `  
` `commandAndParams.add("--instruction-set=" + getCurrentInstructionSet());` `  
` `// verify-none|interpret-only|verify-at-runtime|space|balanced|speed|everything|time` `  
` `//编译模式，不同的模式，影响最终的运行速度和磁盘大小的占用` `  
` `if (mode == Dex2OatCompMode.FASTEST_NONE) {` `  
` `    commandAndParams.add("--compiler-filter=verify-none");` `  
` `} else if (mode == Dex2OatCompMode.FASTER_ONLY_VERIFY) {` `  
` `    //快速编译` `  
` `    if (Build.VERSION.SDK_INT > 25) {` `  
` `        commandAndParams.add("--compiler-filter=quicken");` `  
` `    } else {` `  
` `        commandAndParams.add("--compiler-filter=interpret-only");` `  
` `    }` `  
` `} else if (mode == Dex2OatCompMode.SLOWLY_ALL) {` `  
` `    //全量编译` `  
` `    commandAndParams.add("--compiler-filter=speed");` `  
` `}` `  
` `//源码路径（apk or dex路径）` `  
` `commandAndParams.add("--dex-file=" + sourceFilePath);` `  
` `//dex2oat产物路径` `  
` `commandAndParams.add("--oat-file=" + optimizedFilePath);` `  
` `  
` `  
` `String[] cmd= commandAndParams.toArray(new String[commandAndParams.size()]);` `  
` `  
` `  
` `//step2 执行命令` `  
` `Runtime.getRuntime().exec(cmd)` `  
`

复制代码

将上述拼接的`dex2oat`命令在``` Android`` ``9 ```机器的`App`进程触发执行，确实得到符合预期的`dex2oat`产物，并可以正常加载和使用，说明命令拼接的是`OK`的，然后将上述命令在`Android 10` 且`targetSdkVersion>=29`机器的`App`进程触发执行，发现并没有得到`dex2oat`产物，并且得到如下日志：

`type=1400 audit(0.0:569): avc: denied { execute } for name="dex2oat" dev="dm-2" ino=222 scontext=u:r:untrusted_app:s0:c12,c257,c512,c768 tcontext=u:object_r:dex2oat_exec:s0 tclass=file permissive=0` `  
`

复制代码

这个日志说明了什么呢？

可以看到日志信息里有`avc: denied`关键词，说明此操作受`SELinux`规则管控，并被拒绝。

在进行日志分析之前，先补充一下`SELinux`的相关知识，下面是`Google官方`的说明：

> Android 使用安全增强型 Linux (SELinux) 对所有进程强制执行强制访问控制 (MAC)，甚至包括以 Root/超级用户权限运行的进程（Linux 功能）

简单说，`SELinux`就是`Android`系统以进程维度对其进行强制访问控制的管理体系。`SELinux`是依靠配置的规则对进程进行约束访问权限。

下面回归正题，分析下日志。

日志细节分析如下：

* `type=1400` ：表示`SYSCALL`；
* ``` denied { ``execute`` } ```：表示`执行权限`被拒绝；
* ``` scontext=u:r:``untrusted_app``:s0:c12,c257,c512,c768 ```：表示主体的安全上下文，其中`untrusted_app`是`source type`；
* ``` tcontext=u:object_r:``dex2oat_exec``:s0 ``` ：表示目标资源的安全上下文，其中`dex2oat_exec`是`target type`；
* `tclass=file`：表示目标资源的`class`类型
* `permissive=0`：当前的`SELLinux`模式，`1`表示`permissive`(宽松的)，`0`表示`enforcing`（严格的）

简单的说就是，当在`Android 10` 且`targetSdkVersion>=29`的机器上的`App`进程上执行拼接的`dex2oat`命令的时候，是由`untrusted_app` \*\*\*\*触发`dex2oat_exec` **，** 而由于`untrusted_app`的规则限制，导致其触发`dex2oat_exec`的`execute`权限被拒绝。

下面简单总结一下：

1. 限制 1：`Android 10+`系统删除了在构建`ClassLoader`时触发`dex2oat`的相关代码，来限制从`应用进程`触发`dex2oat`的入口。
2. 限制 2：`Android 10+`系统的相关`SELinux`规则变更，限制`targetSdkVersion>=29`的时候从`应用进程`触发`dex2oat`。

现在通过查阅相关代码和`SELinux`规则以及使用代码验证，真正的见识到了限制到底是什么样子的，又是如何生效的，以及真真切切的感受到它的威力......

那既然知道限制是什么以及限制如何生效的了，那是否可以绕过呢？

## 限制能否绕过？

通过上面对限制的了解，可以先大胆的假设：

1. `targetSdkVersion`设置小于`29`
2. 伪装应用进程为系统进程
3. 关闭`Android`系统的`SELinux`检测
4. 修改规则移除限制

下面开始小心求证，上述假设是否可行？

对于`假设1`来说，如果全局设置`targetSdkVersion`小于`29`的话，则会影响`App`后续在应用商店的上架，如果局部设置`targetSdkVersion`小于`29`的话，不仅难以修改且时机难以把握，`dex2oat`是单独的进程进行编译操作的，不同的进程对其进行触发编译的时候，会将进程的`targetSdkVersion`信息作为参数传给它，用于它内部逻辑的判断，而进程信息是存在于系统进程的。

对于`假设2`来说，目前还没相关的已知操作可以做到类似效果...

对于`假设3`来说，`Android`系统确实也提供了关闭`SELinux`检测的方法，但是需要`Root`权限。

对于`假设4`来说，如果全局修改规则，需要重新编译系统，才可以生效，如果局部修改规则（内存中修改），此处所需的权限也比较高，也无权操作。

所以，从目前来看，绕过基本不可行了...

那怎么办？限制绕不过去，目标无法达成了...

或许谜底就在谜面上，既然`Android`系统限制只能使用系统生成的，那我们就用系统生成的？

只需要让系统可以感知到我们的操作，可以根据我们提供的操作去生成，可以由我们去控制生成的时机以及效果，这样不如同在`应用进程`触发`dex2oat`有一样的效果了嘛？

那如何操作呢？

## 借助系统的能力？

系统是否提供了可以供`应用进程`触发系统行为，然后由系统触发`dex2oat`的方式？

通过查阅 Android 的官方文档以及相关代码发现可以通过如下方式进行操作（[强制编译](https://xie.infoq.cn/link?target=https%3A%2F%2Fsource.android.com%2Fdevices%2Ftech%2Fdalvik%2Fjit-compiler%23force-compilation-of-a-specific-package)）：

* 基于配置文件编译：`adb shell cmd package compile -m speed-profile -f my-package`
* 全面编译：`adb shell cmd package compile -m speed -f my-package`

上述命令不仅支持选择编译模式(`speed-profile` or `speed`)，而且还可以选择特定的`App`进行操作（`my-package`）。

通过运行上述命令发现确实可以在`targetSdkVersion>=29`且`Android 10+`的系统上编译出对应的`dex2oat`产物，且可以正常加载使用！！！

但是上述命令仅支持`Primary Apk`并不支持`Secondary Apk`，感觉它的功能还不止于此，还可以继续挖掘一下这个命令的潜力，下面看下这个命令的实现。

分析之前需要先确定命令对应的代码实现，这里使用了个小技巧，通过故意输错命令，发现最终崩溃的位置在`PackageManagerShellCommand`，然后通过`debug`源码，梳理了一下完整的代码调用流程，细节如下。

为了方便理解，下面将代码的调用流程使用时序图描述出来。

下图为`Primary Apk`的编译流程：

![](https://proxy-prod.omnivore-image-cache.app/0x0,s1yy6UEE5dj2YJF-KUHSYqP8tCog6AERM7Un0DwyHXXc/https://static001.geekbang.org/infoq/d7/d74da0e031cd091e9af5a1cc36e6e4af.png)

在梳理`Primary Apk`的编译流程的时候，发现代码中也有处理`Secondary Apk`的方法，下面梳理流程如下：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sckMVfEjNhkroPsDtwWUy_UfZSBXZ537o7nK1aaaYtTk/https://static001.geekbang.org/infoq/7e/7eafa7b299cc54aabc8e1be3adae496e.png)

然后根据其代码，梳理其编译命令为：`adb shell cmd package compile -m speed -f --secondary-dex my-package`  

至此，我们已经得到了一种可以借助命令使系统触发`dex2oat`编译的方式，且可以支持`Primary Apk`和`Secondary Apk`。

还有一些细节需要注意，`Primary Apk`的命令传入的是 App 的包名，`Secondary Apk`的命令传入的也是包名，那哪些`Secondary Apk`会参与编译呢？

这就涉及到`Secondary Apk`的注册了，只有注册了的`Secondary Apk`才会参与编译。

下面是`Secondary Apk`注册的流程：

![](https://proxy-prod.omnivore-image-cache.app/0x0,smB8XNT1MYE3UpfBolxafByDoPtQ32HTG1Q_wF_VsdTk/https://static001.geekbang.org/infoq/9e/9eadc46929f4b5aa02e4753d15e0cae7.png)

对于`Secondary Apk`来说只注册不反注册也不行，因为对于`Secondary Apk`来说，每次编译仅想编译新增的或者未被编译过的，对于已经编译过的，是不想其仍参与编译，所以这些已经编译过的，就需要进行反注册。

下面是`Secondary Apk`反注册的流程：

![](https://proxy-prod.omnivore-image-cache.app/0x0,siwwPtju79hhA4wsBAVGSFros_tfguKJ2dLXrJmk0P_4/https://static001.geekbang.org/infoq/a9/a915f56b0d0225f0bf2e83b619814aef.png)

而且通过查看源码发现，触发此处的方式其实有两种：

1. **方式一**：使用`adb shell cmd package + 命令`。例如`adb shell cmd package compile -m quicken com.bytedance.demo` ，其含义就是触发`runCompile`方法，然后指定编译模式为`quicken`，指定编译的包名为`com.bytedance.demo`，由于没有指定是`Secondary`，所以按照`Primary`编译。然后其底层通过`socket+binder`完成通信，最终交由`PackageManager`的`Binder`处理。
2. **方式二**：使用`PackageManager`的`Binder`，并设定`code=SHELL_COMMAND_TRANSACTION`，然后将命令以数组的形式封装到`data`内即可。

对于方式一来说，依赖`adb`的实现，底层通信需要依赖`socket + binder`，而对于方式二来说，底层通信直接使用`binder`，相比来说更高效，所以最终选择第二种方式。

下面简单的总结一下。

在得知限制无法被绕过后，就想到是否可以使得`应用进程`可以触发系统行为，然后由系统触发`dex2oat`，然后通过查阅官方文档找到对应的`adb命令`可以满足诉求，不过此时仅看到`Primary Apk`的相关实现，然后继续通过查看代码验证其流程，找到`Secondary Apk`的相关实现，然后根据实际场景的需要，又继续查看代码，找到注册`Secondary Apk`和反注册`Secondary Apk`的方法，然后通过对比`adb命令`的实现和`binder`的实现差异，最终选用`binder`的实现方式，来完成上述操作。

既然探索已经完成，那么下面就根据探索的结果，完成落地实践，并验证其效果。

## 实践

## 操作

示例代码如下：

`//执行快速编译` `  
` `@Override` `  
` `public void dexOptQuicken(String pluginPackageName, int version) {` `  
` `    //step1：如果没有初始化则初始化` `  
` `    maybeInit();` `  
` `    //step2:将apk路径进行注册到PMS` `  
` `    registerDexModule(pluginPackageName, version);` `  
` `    //step3:使用binder触发快速编译` `  
` `    dexOpt(COMPILE_FILTER_QUICKEN, pluginPackageName, version);` `  
` `    //step4:将apk路径反注册到PMS` `  
` `    unregisterDexModule(pluginPackageName, version);` `  
` `}` `  
` `  
` `  
` `//执行全量编译` `  
` `@Override` `  
` `public void dexOptSpeed(String pluginPackageName, int version) {` `  
` `    //step1：如果没有初始化则初始化` `  
` `    maybeInit();` `  
` `    //step2:将apk路径进行注册到PMS` `  
` `    registerDexModule(pluginPackageName, version);` `  
` `    //step3:使用binder触发全量编译` `  
` `    dexOpt(COMPILE_FILTER_SPEED, pluginPackageName, version);` `  
` `    //step4:将apk路径反注册到PMS` `  
` `    unregisterDexModule(pluginPackageName, version);` `  
` `}` `  
`

复制代码

## 实现

` /**` `  
` ` * Try To Init (Build Base env)` `  
` ` */` `  
` `private void maybeInit() {` `  
` `    if (mContext == null || mPmBinder != null) {` `  
` `        return;` `  
` `    }` `  
` `  
` `  
` `    PackageManager packageManager = mContext.getPackageManager();` `  
` `  
` `  
` `    Field mPmField = safeGetField(packageManager, "mPM");` `  
` `    if (mPmField == null) {` `  
` `        return;` `  
` `    }` `  
` `  
` `  
` `    mPmObj = safeGetValue(mPmField, packageManager);` `  
` `    if (!(mPmObj instanceof IInterface)) {` `  
` `        return;` `  
` `    }` `  
` `  
` `  
` `    IInterface mPmInterface = (IInterface) mPmObj;` `  
` `    IBinder binder = mPmInterface.asBinder();` `  
` `    if (binder != null) {` `  
` `        mPmBinder = binder;` `  
` `    }` `  
` `}` `  
` `  
` `  
` ` /**` `  
` ` * DexOpt (Add Retry Function)` `  
` ` */` `  
` `private void dexOpt(String compileFilter, String pluginPackageName, int version) {` `  
` `    String tempFilePath = PluginDirHelper.getTempSourceFile(pluginPackageName, version);` `  
` `    String tempCacheDirPath = PluginDirHelper.getTempDalvikCacheDir(pluginPackageName, version);` `  
` `    String tempOatDexFilePath = tempCacheDirPath + File.separator + PluginDirHelper.getOatFileName(tempFilePath);` `  
` `    File tempOatDexFile = new File(tempOatDexFilePath);` `  
` `  
` `  
` `    for (int retry = 1; retry <= MAX_RETRY_COUNT; retry++) {` `  
` `        execCmd(buildDexOptArgs(compileFilter), null);` `  
` `        if (tempOatDexFile.exists()) {` `  
` `            break;` `  
` `        }` `  
` `    }` `  
` `}` `  
` `  
` `  
` ` /**` `  
` ` * Register DexModule(dex path) To PMS` `  
` ` */` `  
` `private void registerDexModule(String pluginPackageName, int version) {` `  
` `    if (pluginPackageName == null || mContext == null) {` `  
` `        return;` `  
` `    }` `  
` `  
` `  
` `    String originFilePath = PluginDirHelper.getSourceFile(pluginPackageName, version);` `  
` `    String tempFilePath = PluginDirHelper.getTempSourceFile(pluginPackageName, version);` `  
` `    safeCopyFile(originFilePath, tempFilePath);` `  
` `  
` `  
` `    String loadingPackageName = mContext.getPackageName();` `  
` `    String loaderIsa = getCurrentInstructionSet();` `  
` `    notifyDexLoad(loadingPackageName, tempFilePath, loaderIsa);` `  
` `}` `  
` `  
` `  
` ` /**` `  
` ` * Register DexModule(dex path) To PMS By Binder` `  
` ` */` `  
` `private void notifyDexLoad(String loadingPackageName, String dexPath, String loaderIsa) {` `  
` `    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {` `  
` `        //deal android 11\12` `  
` `        realNotifyDexLoadForR(loadingPackageName, dexPath, loaderIsa);` `  
` `    } else {` `  
` `        //deal android 10` `  
` `        realNotifyDexLoad(loadingPackageName, dexPath, loaderIsa);` `  
` `    }` `  
` `}` `  
` `  
` `  
` ` /**` `  
` ` * Register DexModule(dex path) To PMS By Binder for R+` `  
` ` */` `  
` `private void realNotifyDexLoadForR(String loadingPackageName, String dexPath, String loaderIsa) {` `  
` `    if (mPmObj == null || loadingPackageName == null || dexPath == null || loaderIsa == null) {` `  
` `        return;` `  
` `    }` `  
` `    Map<String, String> maps = Collections.singletonMap(dexPath, "PCL[]");` `  
` `    safeInvokeMethod(mPmObj, "notifyDexLoad",` `  
` `            new Object[]{loadingPackageName, maps, loaderIsa},` `  
` `            new Class[]{String.class, Map.class, String.class});` `  
` `}` `  
` `  
` `  
` ` /**` `  
` ` * Register DexModule(dex path) To PMS By Binder for Q` `  
` ` */` `  
` `private void realNotifyDexLoad(String loadingPackageName, String dexPath, String loaderIsa) {` `  
` `    if (mPmObj == null || loadingPackageName == null || dexPath == null || loaderIsa == null) {` `  
` `        return;` `  
` `    }` `  
` `    List<String> classLoadersNames = Collections.singletonList("dalvik.system.DexClassLoader");` `  
` `    List<String> classPaths = Collections.singletonList(dexPath);` `  
` `    safeInvokeMethod(mPmObj, "notifyDexLoad",` `  
` `            new Object[]{loadingPackageName, classLoadersNames, classPaths, loaderIsa},` `  
` `            new Class[]{String.class, List.class, List.class, String.class});` `  
` `}` `  
` `  
` `  
` ` /**` `  
` ` * UnRegister DexModule(dex path) To PMS` `  
` ` */` `  
` `private void unregisterDexModule(String pluginPackageName, int version) {` `  
` `    if (pluginPackageName == null || mContext == null) {` `  
` `        return;` `  
` `    }` `  
` `  
` `  
` `    String originDir = PluginDirHelper.getSourceDir(pluginPackageName, version);` `  
` `    String tempDir = PluginDirHelper.getTempSourceDir(pluginPackageName, version);` `  
` `    safeCopyDir(tempDir, originDir);` `  
` `  
` `  
` `    String tempFilePath = PluginDirHelper.getTempSourceFile(pluginPackageName, version);` `  
` `    safeDelFile(tempFilePath);` `  
` `  
` `  
` `    reconcileSecondaryDexFiles();` `  
` `}` `  
` `  
` `  
` ` /**` `  
` ` * Real UnRegister DexModule(dex path) To PMS (By Binder)` `  
` ` */` `  
` `private void reconcileSecondaryDexFiles() {` `  
` `    execCmd(buildReconcileSecondaryDexFilesArgs(), null);` `  
` `}` `  
` `  
` `  
` ` /**` `  
` ` * Process CMD (By Binder)（Have system permissions）` `  
` ` */` `  
` `private void execCmd(String[] args, Callback callback) {` `  
` `    Parcel data = Parcel.obtain();` `  
` `    Parcel reply = Parcel.obtain();` `  
` `    data.writeFileDescriptor(FileDescriptor.in);` `  
` `    data.writeFileDescriptor(FileDescriptor.out);` `  
` `    data.writeFileDescriptor(FileDescriptor.err);` `  
` `    data.writeStringArray(args);` `  
` `    data.writeStrongBinder(null);` `  
` `  
` `  
` `    ResultReceiver resultReceiver = new ResultReceiverCallbackWrapper(callback);` `  
` `    resultReceiver.writeToParcel(data, 0);` `  
` `  
` `  
` `    try {` `  
` `        mPmBinder.transact(SHELL_COMMAND_TRANSACTION, data, reply, 0);` `  
` `        reply.readException();` `  
` `    } catch (Throwable e) {` `  
` `        //Report info` `  
` `    } finally {` `  
` `        data.recycle();` `  
` `        reply.recycle();` `  
` `    }` `  
` `}` `  
` `  
` `  
` ` /**` `  
` ` * Build dexOpt args` `  
` ` *` `  
` ` *  @param compileFilter compile filter` `  
` ` *  @return cmd args` `  
` ` */` `  
` `private String[] buildDexOptArgs(String compileFilter) {` `  
` `    return buildArgs("compile", "-m", compileFilter, "-f", "--secondary-dex",` `  
` `            mContext == null ? "" : mContext.getPackageName());` `  
` `}` `  
` `  
` `  
` ` /**` `  
` ` * Build ReconcileSecondaryDexFiles Args` `  
` ` *` `  
` ` *  @return cmd args` `  
` ` */` `  
` `private String[] buildReconcileSecondaryDexFilesArgs() {` `  
` `    return buildArgs("reconcile-secondary-dex-files", mContext == null ? "" : mContext.getPackageName());` `  
` `}` `  
` `  
` `  
` ` /**` `  
` ` * Get the InstructionSet through reflection` `  
` ` */` `  
` `private String getCurrentInstructionSet() {` `  
` `    String currentInstructionSet;` `  
` `    try {` `  
` `        Class vmRuntimeClazz = Class.forName("dalvik.system.VMRuntime");` `  
` `        currentInstructionSet = (String) MethodUtils.invokeStaticMethod(vmRuntimeClazz,` `  
` `                "getCurrentInstructionSet");` `  
` `    } catch (Throwable e) {` `  
` `        currentInstructionSet = "arm64";` `  
` `    }` `  
` `    return currentInstructionSet;` `  
` `}` `  
`

复制代码

## 验证

下面是针对本方案兼容性验证的结果：

![](https://proxy-prod.omnivore-image-cache.app/0x0,szxV68NO1dIFBVX-CEjLs02JE6T0iBj_qYDqUmIqLlr4/https://static001.geekbang.org/infoq/f7/f7ce5df140d1d10ba37b0ad33ed4932d.png)

目前来看，对于手机品牌来说，该方案均可以兼容，仅`Oppo且Android 11`的机器上，由于对`Rom`进行了修改限制，导致此款机器不兼容。

兼容效果还算良好。

## Android 10+ 优化前后 Dex 加载速度对比

下面针对高中低端的机器上，验证下优化前后`Dex`加载速度的差异：

![](https://proxy-prod.omnivore-image-cache.app/0x0,srG2eLMwqWEHDcqCmbeuhjSSZ-XIDy95WAyzIgmM4d4E/https://static001.geekbang.org/infoq/b3/b38a5efb0dfb8db8f323a61dfdafc076.png)

对于`Dex加载`耗时的统计，是采用统计首次`new ClassLoader`时`Dex`加载的耗时。

`Dex加载`耗时同`包大小`属于`正相关`，包越大，加载耗时越多；同`机器性能`属于`负相关`，机器性能越好，加载耗时越少。

通过上述数据可以看出，优化前后耗时差距还是非常明显的，机器性能越差优化越明显。

`Dex加载`速度优化明显。

## Android 10+ 优化前后场景运行耗时对比

下面针对高中低端的机器上，验证下优化前后场景运行速度的差异：

![](https://proxy-prod.omnivore-image-cache.app/0x0,s3RV3XasjOKLL5cuLPuH4l4AUPfHt-osWTlJWyXKoneg/https://static001.geekbang.org/infoq/79/797c3d5fc69a8985af48f296b4a3790b.png)

对于场景运行耗时的统计，是采用对场景启动前后打点，然后计算时间差。

由于非全量编译对运行速度影响较小，上述数据为未优化同全量编译优化的对比数据。

`场景耗时`同`场景复杂度`属于`正相关`，场景复杂度越高，场景耗时越多；同`机器性能`属于`负相关`，机器性能越好，场景耗时越少。

通过上述数据可以看出，优化后对运行速度还是有质的提升的，且会随场景复杂度的提升，带来更大的提升。

## 总结

最终，通过假借系统之手来触发`dex2oat`的方式，绕过`targetSdkVersion>=29`且`Android10+`上的限制，效果较为明显，`dex`加载速度提升`80%`以上，场景运行速度提升`11%`以上。

**关于字节终端技术团队**

字节跳动终端技术团队(Client Infrastructure)是大前端基础技术的全球化研发团队（分别在北京、上海、杭州、深圳、广州、新加坡和美国山景城设有研发团队），负责整个字节跳动的大前端基础设施建设，提升公司全产品线的性能、稳定性和工程效率；支持的产品包括但不限于抖音、今日头条、西瓜视频、飞书、懂车帝等，在移动端、Web、Desktop 等各终端都有深入研究。

就是现在！客户端／前端／服务端／端智能算法／测试开发 面向全球范围招聘！一起来用技术改变世界，感兴趣请联系 chenxuwei.cxw@bytedance.com，邮件主题简历-姓名-求职意向-期望城市-电话。

[字节跳动应用开发套件MARS](https://xie.infoq.cn/link?target=https%3A%2F%2Fwww.volcengine.com%2Fproduct%2Fvemars%2F%3Futm%5Fsource%3Dwechat%26utm%5Fmedium%3Darticle%26utm%5Fterm%3Dwx%5Freadmore%26utm%5Fcampaign%3Dshouye%26utm%5Fcontent%3Dvemars)是字节跳动终端技术团队过去九年在抖音、今日头条、西瓜视频、飞书、懂车帝等 App 的研发实践成果，面向移动研发、前端开发、QA、 运维、产品经理、项目经理以及运营角色，提供一站式整体研发解决方案，助力企业研发模式升级，降低企业研发综合成本。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sOEPu6dnJkUd8e7-IutEKsY7-gYifI1Moo3WipFiLHig/https://static001.geekbang.org/infoq/e3/e3e5bd2d7c28d6d7cd13b794f4323ecc.webp?x-oss-process=image%2Fresize%2Cp_80%2Fformat%2Cpng)

可扫码添加小助手微信，了解更多详情

---

