---
id: 96e8fa99-f098-472b-a2a1-f10e926c8489
---

# Android 隐私合规检查工具套装 - 掘金
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-18cfba3b062)
[Read Original](https://juejin.cn/post/7322714226290999306)

之前写过一篇《[隐私合规代码排查思路](https://juejin.cn/post/7042967031599071269 "https://juejin.cn/post/7042967031599071269")》的文章，但文章没有将方案开源出来，总觉得差了那么点意思，这次打算把几种常规的检测方法都开源出来，给大家一些借鉴思路。

对于一套完整的隐私合规检查来说，动静结合是非常有必要的，静态用于扫描整个应用隐私 api 的调用情况，动态用于在运行时同意隐私弹框之前是否有不合规的调用，以下列出一些常规的检查方案：

![](https://proxy-prod.omnivore-image-cache.app/0x0,s0ELSi7hYyOLBoFRNqN4w5C4jw8cCJvAThA9LbHw10us/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4aed578576744c24ac02bd36dae5ffb2~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1138\&h=554\&s=56467\&e=jpg\&b=fefefe)

思维导图中 ✅ 打钩的部分都已经实现，后面会讲解这些方案适合应用在什么场景，他们之间有哪些优缺点。

**以上所有工具的实现，都是基于隐私配置文件 privacy\_api.json 来实现的，也即意味着，你只需要维护一份配置文件即可。**

## 一、静态检查

### 1、基于项目依赖的字节码扫描

扫描工程下的所有依赖，提取依赖 jar 包下的所有 Class 文件，利用 ASM 工具分析 Class 文件下的所有方法的 insn 指令，找出是否有调用隐私 api 的情况，实现代码片段：

```reasonml
// 1、读取隐私 api 配置文件
val apiList: List<ApiNode> = Gson().fromJson(configFile.bufferedReader(), type)

// 2、获取项目所有依赖
val resolvableDeps = project.configurations.getByName(configurationName).incoming
resolvableDeps.artifactView { conf ->
    conf.attributes { attr ->
        attr.attribute(
            AndroidArtifacts.ARTIFACT_TYPE,
            AndroidArtifacts.ArtifactType.CLASSES_JAR.type
        )
    }
}

// 3、ASM 分析 Class 文件
clazz.methods?.forEach {
    it.instructions
        .filterIsInstance(MethodInsnNode::class.java)
        .forEach Continue@{ node ->
            val callClazz = getClassName(node.owner) ?: return@Continue
            val callMethod = node.name
            checkApiCall(callClazz, callMethod, it.name, clazz, apiList)
        }
}

```

扫描出来的结果示例：

```json
[ 
  "android.location.LocationManager_requestLocationUpdates": [
    {
      "clazz": "androidx/core/location/LocationManagerCompat$Api31Impl",
      "method": "requestLocationUpdates",
      "dep": "androidx.core:core:1.9.0"
    },
    {
      "clazz": "androidx/core/location/LocationManagerCompat",
      "method": "getCurrentLocation",
      "dep": "androidx.core:core:1.9.0"
    }
  ]
]

```

由于是依赖扫描，也即意味着 app 工程下的代码是无法参与扫描的，该方案适合基于壳工程的组件化方案，一般壳工程只有一个 Application 类，其他业务组件都是以依赖的方式集成进壳工程打包，该方案的优点是，可以根据扫描出来的结果快速找到模块负责人，并完成修改。

集成方案查看 github 的 DepCheck 插件 [README](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2FMRwangqi%2FPrivacyCheck%2Ftree%2Fmaster%2FDepCheck "https://github.com/MRwangqi/PrivacyCheck/tree/master/DepCheck") 说明

### 2、基于 apk 的 smali 扫描

网易云音乐曾经发表过一篇基于 smali 扫描的《[Android 隐私合规静态检查](https://link.juejin.cn/?target=https%3A%2F%2Fmusicfe.com%2Fandroid-privacy%2F "https://musicfe.com/android-privacy/")》文章，思路就是将 apk 解压，提取出 dex 文件，然后使用 baksmali 库将 dex 转成 smali 文件，然后逐行分析 smali 的方法调用情况，扫描出来的结果示例：

```json
[
  "android.location.LocationManager_requestLocationUpdates": [
    {
      "clazz": "public final Landroidx.core.location.LocationManagerCompat;",
      "method": "public static getCurrentLocation(Landroid/location/LocationManager;Ljava/lang/String;Landroidx/core/os/CancellationSignal;Ljava/util/concurrent/Executor;Landroidx/core/util/Consumer;)V"
    },
    {
      "clazz": "public final Landroidx.core.location.LocationManagerCompat;",
      "method": "public static requestLocationUpdates(Landroid/location/LocationManager;Ljava/lang/String;Landroidx/core/location/LocationRequestCompat;Landroidx/core/location/LocationListenerCompat;Landroid/os/Looper;)V"
    }
  ]
]

```

由于是基于 apk 扫描，可以直接对各业务线的所有 apk 进行扫描，相比较需要集成进项目打包的扫描工具来说，不用每条业务线都去集成插件，扫描效率比较高。并且，该工具非常适合非开发人员使用，例如测试版本回归时，对最终产物 apk 进行扫描，以此来确定当前版本是否有不合规的调用。当然，基于 apk 的扫描也有缺点，无法像依赖检查那样快速定位到该类是哪个模块的，也即无法快速找到模块负责人。

该方案的实现使用的是 Java Console Application 工程开发的 CLI 工具，可以直接执行命令行来分析结果，只需要提供 apk 路径与隐私 api 配置文件即可(但需要本地 Java 环境)，例如：

> ./ApkCheck /xx/xx/xx.apk /xxx/xx/api.json

具体使用文档查看 github 的 ApkCheck 的 [README](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2FMRwangqi%2FPrivacyCheck%2Ftree%2Fmaster%2FApkCheck "https://github.com/MRwangqi/PrivacyCheck/tree/master/ApkCheck") 说明。

### 3、Lint 检查

Lint 检查的主要作用是在开发阶段就遏制住隐私 api 的乱调情况，提前暴露问题，实现代码片段：

```reasonml
// 1、读取工程根目录的隐私配置文件
open class BaseDetector : Detector() {
    override fun beforeCheckFile(context: Context) {
        super.beforeCheckFile(context)
        val apiJson = File(context.project.dir.parentFile,API_JSON)
        apiNode = Gson().fromJson(apiJson.bufferedReader(), type)
    }
}

// 2、检查方法调用是否涉及隐私 api 
private class ApiCallUastHandler(val context: JavaContext?) : UElementHandler() {

        override fun visitCallExpression(node: UCallExpression) {
            if (node.isMethodCall()) {
                apiNode.find {
                    context?.evaluator?.isMemberInClass(node.resolve(), it.clazz) == true
                            && it.method.find { m -> m == node.methodName } != null
                }?.let {
                    context?.report(
                        ISSUE,
                        node,
                        context.getLocation(node),
                        REPORT_MESSAGE
                    )
                }
            }
        }
    }

```

检查效果如下：

![image.png](https://proxy-prod.omnivore-image-cache.app/0x0,sBJlqjxP5xjfRLw0-O_JaorymERBIUX3clXUXeD2MsF4/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6b4bfb42acb14736bb80109bfa07101d~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1236\&h=476\&s=135569\&e=png\&b=2b2b2b)

输出的报告：

![image.png](https://proxy-prod.omnivore-image-cache.app/0x0,s_dAw5OansXnj3lOp7ZOaYHWgUt1KVmlKolRYAh17d2o/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0448fd54e5804ea79531eaffcfa736d7~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1690&h=634&s=170384&e=png&b=fdfbfb)

具体集成方案查看 github 的 LintCheck 的 [README](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2FMRwangqi%2FPrivacyCheck%2Ftree%2Fmaster%2FLintCheck "https://github.com/MRwangqi/PrivacyCheck/tree/master/LintCheck") 说明

## 二、动态检查

在上面的思维导图中，动态检查 Xposed 与 transform 插桩我是没有实现的，因为我发现这两个方案的 ROI 非常低，并且后期难以维护：

1. 对于 Xposed 方案来说，需要搭配系统 root，对开发与测试都非常不友好，测试环境过于狭窄，即使是基于非 root 的 [VirtualXposed](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Fandroid-hacker%2FVirtualXposed "https://github.com/android-hacker/VirtualXposed") ，系统版本兼容性又存在很大的问题，官方 README 描述仅支持 5.0 \~ 10.0 系统，测试环境依然过于狭窄。并且，对于一心只想解决隐私 api 调用情况的 UI 仔来说，Xposed 方案有点过重
2. 对于 transfrom 插桩来说，这完全就不是一个可行方案，如果你在 transform 阶段做静态扫描，那完全可以通过依赖扫描来解决。如果你想做运行时 hook 替换，你就得解决 invoke-static 与 invoke-virtual 的替换，这两个指令的处理还不一样，并且，你说你要替换，那你替换成啥呢，你的 utils 工具类？那你就要写很多的模版代码，那未来隐私 api 再增加呢，再去写一遍模版代码吗？这后期维护也太难了。

动态检查的唯一解只有运行时 AOP Hook。

### 1、基于运行时的 AOP hook 框架

在之前文章 《[隐私合规代码排查思路](https://juejin.cn/post/7042967031599071269 "https://juejin.cn/post/7042967031599071269")》中介绍过使用 [epic](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Ftiann%2Fepic%2Fblob%2Fmaster%2FREADME%5Fcn.md "https://github.com/tiann/epic/blob/master/README_cn.md") 来实现 AOP hook，但 epic 仅支持 Android 5.0 \~ 11，对于手持 12 系统的我来说，非常不方便，故而重新搜了下类 epic 的框架。 你还别说，还真找着了，那就是 [Pine](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Fcanyie%2Fpine%2Fblob%2Fmaster%2FREADME%5Fcn.md "https://github.com/canyie/pine/blob/master/README_cn.md")，支持 Android 4.4(只支持ART) \~ 14 且使用 thumb-2/arm64 指令集的设备，用法与 epic 相近，如下是一个简单的 AOP Hook 操作：

```kotlin
 Pine.hook(Method, object : MethodHook() {
            override fun beforeCall(callFrame: Pine.CallFrame) {
                addStackLog(method.declaringClass.name, method.name)
            }

            override fun afterCall(callFrame: Pine.CallFrame) {}
        })

```

那么，我们的实现思路就可以读取隐私合规 api 配置文件，然后调用 Pine.hook 即可。运行时效果如下：

![image.png](https://proxy-prod.omnivore-image-cache.app/0x0,s_Z91ciG-EdHSeZWWeKKCS6KVJ4V7aol1U8IwfVCieLA/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a5f57b04724d43f1a8d0bd1e24cb0474~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1762\&h=888\&s=264783\&e=png\&b=2b2b2b)

该方案优点是对 Android 系统版本兼容覆盖比较全，可以在不改变原有业务代码的情况下实现 AOP Hook，缺点就是只能针对自己应用进行 Hook，并且只能 Hook Java Method。

具体集成方案查看 github 的 RuntimeCheck 的 [README](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2FMRwangqi%2FPrivacyCheck%2Ftree%2Fmaster%2FRuntimeCheck "https://github.com/MRwangqi/PrivacyCheck/tree/master/RuntimeCheck") 说明。

题外话：

* Pine 的实现思路可以看《[ART上的动态Java方法hook框架](https://link.juejin.cn/?target=https%3A%2F%2Fblog.canyie.top%2F2020%2F04%2F27%2Fdynamic-hooking-framework-on-art%2F "https://blog.canyie.top/2020/04/27/dynamic-hooking-framework-on-art/")》，这是一篇 2020 年写的文章，关于信息里面，作者当前年龄 19 岁.....

### 2、基于 frida 的免 root 方案

基于 Frida 的方案，我最先接触的是 [camille](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Fzhengjim%2Fcamille "https://github.com/zhengjim/camille")，但该方案需要 root，它可以无侵入的实现所有应用的监测，但从 README 与 issue 来看，问题不少。 在搜索同类工具时，有很多采用 frida-server 的方式，需要通过 adb 将 frida-server push 到手机内，然后启动该服务，听着就头皮发麻。 后面搜到 [frida gadget ](https://link.juejin.cn/?target=https%3A%2F%2Ffrida.re%2Fdocs%2Fgadget%2F%23script "https://frida.re/docs/gadget/#script")方案，可以直接配置 js 脚本来实现 hook，无需 frida-server：

![image.png](https://proxy-prod.omnivore-image-cache.app/0x0,sJSKQoIpI5nHy_LSlepyKE4htelNB9T0qWIC7-8NcmAs/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b1b85f4797b94477993ed319fb68c841~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=748\&h=408\&s=38859\&e=png\&b=f1f1f1)

大体实现步骤：

1. 下载 android arm 架构的 [frida-gadget.so](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Ffrida%2Ffrida%2Freleases "https://github.com/frida/frida/releases"), 由于 Release 产物比较多，需要点击 Assets 展开更多
2. 创建 script.js 脚本文件，实现隐私 api 的 hook
3. 将 [frida-gadget.so](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Ffrida%2Ffrida%2Freleases "https://github.com/frida/frida/releases") 与 script.js 写入到本地
4. 创建 frida-gadget.config.so 文件，内容结构的 path 指向 script.js 在本地的路径
5. 动态加载 [frida-gadget.so](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Ffrida%2Ffrida%2Freleases "https://github.com/frida/frida/releases") 文件，该 so 会读取 frida-gadget.config.so 中的 path 路径，获取到 script.js 文件，并执行该 js 脚本

运行效果如下：

![image.png](https://proxy-prod.omnivore-image-cache.app/0x0,sastf7P942qZg3C_Bh9tafskeDbRtaXuosIKwhvl1a3M/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d6016e14bdb44741912002fef9d9bc4e~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=2380\&h=852\&s=284186\&e=png\&b=2b2b2b)

该方案的优点不需要 root，并且机型适配比较好，frida 还支持 java/native 的 hook，缺点是，该方案只能针对自己应用进行 Hook。

具体集成方案查看 github FridaCheck 的 [README](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2FMRwangqi%2FPrivacyCheck%2Fblob%2Fmaster%2FFridaCheck%2FREADME.md "https://github.com/MRwangqi/PrivacyCheck/blob/master/FridaCheck/README.md") 说明。

## 总结:

对于上述的几个方案，我还是比较喜欢基于静态方案的 apk smali 扫描与基于动态方案的 frida 无侵入式 [camille](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Fzhengjim%2Fcamille "https://github.com/zhengjim/camille") 方案，这两个方法都无需侵入项目即可实现隐私扫描，适合非开发人员使用。

参考链接:

* [Android Hook 技术](https://link.juejin.cn/?target=https%3A%2F%2Fmeik2333.com%2Fposts%2Fandroid-hook%2F "https://meik2333.com/posts/android-hook/")
* [Frida Gadget](https://link.juejin.cn/?target=https%3A%2F%2Ffrida.re%2Fdocs%2Fgadget%2F "https://frida.re/docs/gadget/")
* [frida Gadget so 免 root 注入 app](https://link.juejin.cn/?target=https%3A%2F%2Fblog.51cto.com%2Fu%5F15127527%2F4546627 "https://blog.51cto.com/u_15127527/4546627")
* [网易云音乐 Android 隐私合规静态检查](https://link.juejin.cn/?target=https%3A%2F%2Fmusicfe.com%2Fandroid-privacy%2F "https://musicfe.com/android-privacy/")
* [Android App 隐私合规检测辅助工具 Camille](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Fzhengjim%2Fcamille "https://github.com/zhengjim/camille")
* [非 root 环境下 frida 的两种使用方式](https://link.juejin.cn/?target=https%3A%2F%2Fnszdhd1.github.io%2F2021%2F06%2F15%2F%25E9%259D%259Eroot%25E7%258E%25AF%25E5%25A2%2583%25E4%25B8%258Bfrida%25E7%259A%2584%25E4%25B8%25A4%25E7%25A7%258D%25E4%25BD%25BF%25E7%2594%25A8%25E6%2596%25B9%25E5%25BC%258F%2F "https://nszdhd1.github.io/2021/06/15/%E9%9D%9Eroot%E7%8E%AF%E5%A2%83%E4%B8%8Bfrida%E7%9A%84%E4%B8%A4%E7%A7%8D%E4%BD%BF%E7%94%A8%E6%96%B9%E5%BC%8F/")
* [Mobile Security Framework (MobSF)](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2FMobSF%2FMobile-Security-Framework-MobSF%3Ftab%3Dreadme-ov-file%23mobile-security-framework-mobsf "https://github.com/MobSF/Mobile-Security-Framework-MobSF?tab=readme-ov-file#mobile-security-framework-mobsf")
* [ART上的动态Java方法hook框架](https://link.juejin.cn/?target=https%3A%2F%2Fblog.canyie.top%2F2020%2F04%2F27%2Fdynamic-hooking-framework-on-art%2F "https://blog.canyie.top/2020/04/27/dynamic-hooking-framework-on-art/")

---

