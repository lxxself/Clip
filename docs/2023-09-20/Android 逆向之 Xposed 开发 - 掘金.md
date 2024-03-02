---
id: d3932d0c-cd53-43cb-96c3-72fe262b8d06
---

# Android 逆向之 Xposed 开发 - 掘金
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-xposed-18ab06277d0)
[Read Original](https://juejin.cn/post/7280435879548911675)

* 大家好，我叫 Jack Darren，目前主要负责国内游戏发行 Android SDK 开发
* 自从上次发布的两篇关于 Android 逆向的文章（[Android 逆向入门保姆级教程](https://juejin.cn/post/7216968724938195001 "https://juejin.cn/post/7216968724938195001") 和 [Android 逆向之脱壳实战篇](https://juejin.cn/post/7245854874196475963 "https://juejin.cn/post/7245854874196475963")）火了之后，从中感觉出来大家对这个系列的文章还是比较感兴趣的，于是续写了这个系列的文章，这次给大家带来的是 Xposed 开发相关的文章。

#### 目录

* [Xposed 介绍](#xposed-%E4%BB%8B%E7%BB%8D "#xposed-%E4%BB%8B%E7%BB%8D")
* [集成 Xposed](#%E9%9B%86%E6%88%90-xposed "#%E9%9B%86%E6%88%90-xposed")
* [使用 Xposed](#%E4%BD%BF%E7%94%A8-xposed "#%E4%BD%BF%E7%94%A8-xposed")
* [Xposed 实现原理](#xposed-%E5%AE%9E%E7%8E%B0%E5%8E%9F%E7%90%86%5D "#xposed-%E5%AE%9E%E7%8E%B0%E5%8E%9F%E7%90%86%5D")
* [Xposed 疑惑解答](#xposed-%E7%96%91%E6%83%91%E8%A7%A3%E7%AD%94 "#xposed-%E7%96%91%E6%83%91%E8%A7%A3%E7%AD%94")

#### Xposed 介绍

* Xposed 框架是一个强大的 Android 逆向工程工具，它允许开发者在不修改应用程序源代码的情况下，动态地注入和修改Android 应用程序的行为。这使得开发者能够执行各种任务，包括修改应用程序的行为、禁用广告、增加新功能、提高隐私保护等。
* Xposed 不仅可以 Hook 目标应用的 API，还可以 Hook 目标应用调用系统的 API，Xposed 可以监控和控制到目标应用的一切 Java 层的操作。
* 使用 Xposed 的前提条件  
   * 手机必须 Root：这里推荐使用 [Magisk](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Ftopjohnwu%2FMagisk "https://github.com/topjohnwu/Magisk")（面具）  
   * 手机必须装 xp 框架：这里推荐使用 [LSPosed](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2FLSPosed%2FLSPosed "https://github.com/LSPosed/LSPosed")，原因也很简单，因为 [XPosed Installer](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Frovo89%2FXposedInstaller "https://github.com/rovo89/XposedInstaller") 和 [EdXposed](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2FElderDrivers%2FEdXposed "https://github.com/ElderDrivers/EdXposed") 已经弃更了，目前只有 LSPosed 还在更新，讲到这里，许多同学应该都懵逼了，这三个到底是啥？有什么关系？这三个其实都是 xp 框架，只不过 XPosed Installer 不维护了，后面就有大神基于这个版本维护了 EdXposed 框架，只是 EdXposed 框架后面也不维护了，又有大神基于 EdXposed 维护了 LSPosed，历史总是在重蹈覆辙。

#### 集成 Xposed

* 第一步：在项目主模块下的 `build.gradle` 文件中加入远程依赖

```roboconf
dependencies {
    // XP 框架：https://github.com/rovo89/Xposed
    compileOnly 'de.robv.android.xposed:api:82'
    compileOnly 'de.robv.android.xposed:api:82:sources'
}

```

* 第二步：在 `AndroidManifest.xml` 中加入配置

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.android.xposed.demo">

    <application>

        <!-- 当前应用是否为 Xposed 模块 -->
        <meta-data
            android:name="xposedmodule"
            android:value="true" />

        <!-- Xposed 模块描述 -->
        <meta-data
            android:name="xposeddescription"
            android:value="我是模块的描述" />

        <!-- 最小要求 Xposed 版本号 -->
        <meta-data
            android:name="xposedminversion"
            android:value="53" />

    </application>

</manifest>

```

![](https://proxy-prod.omnivore-image-cache.app/0x0,sf8vWWo2xIBrqIfOl5WrejMEkD1emIa9-fN2HPaMgtKU/https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/db564be5f5f843dc866dea1579c8a606~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=868&h=1844&s=338330&e=png&a=1&b=f9f9fd)

* 第三步：创建一个 Hook 入口类，示例这里创建了一个名为 XposedHookMain 类

```java
package com.android.xposed.demo;

public class XposedHookMain implements IXposedHookLoadPackage {

    @Override
    public void handleLoadPackage(LoadPackageParam loadPackageParam) throws Throwable {
        // 打印目标应用的包名
        XposedBridge.log("Loaded app: " + loadPackageParam.packageName);
    }
}

```

* 然后在主模块中的 `src/main/assets/`创建一个名为 `xposed_init` 文件，并加入刚刚创建的 Hook 类

```css
com.android.xposed.demo.XposedHookMain

```

* 第四步：打开 Xposed 框架中启用 Xposed 应用，并且选择这个 Xposed 模块对哪些目标应用生效（作用域）

![](https://proxy-prod.omnivore-image-cache.app/0x0,shbsR3UeZbh-j6MHU_RkZ5XZWJFzG_4c9bx-y_4hrGuY/https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cf3c099fd1034fd08adbaba392cccf35~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1067&h=324&s=73148&e=png&b=fafafa)

![](https://proxy-prod.omnivore-image-cache.app/0x0,s9hDVxCnV8AhYJ3wY-KBwRMFDAPqRl5HR5gaPvqUtg5g/https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/190163fdff21448689ceabe3cb9c8196~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1080&h=2400&s=259024&e=png&b=fcfcff)

![](https://proxy-prod.omnivore-image-cache.app/0x0,slxM76IkEMI74ALdydkRkKoYLWEGkiLbpznC4YeyzGSA/https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/87a963b26abe4068b2f94339217e1cb1~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1080&h=2400&s=270963&e=png&b=fcfcff)

* 至此，Xposed 框架使用环境已经搭建完成，可以进行下一步 Hook 操作了

#### 使用 Xposed

* 我如果想 Hook 目标应用的 Application 类的 onCreate 方法的话，可以添加以下 Hook 代码

```java
public class XposedHookMain implements IXposedHookLoadPackage {

    @Override
    public void handleLoadPackage(LoadPackageParam loadPackageParam) throws Throwable {
        // 打印目标应用的包名
        XposedBridge.log("Loaded app: " + loadPackageParam.packageName);

        XposedHelpers.findAndHookMethod("android.app.Application", loadPackageParam.classLoader, "onCreate", new XC_MethodHook() {

            @Override
            protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                super.beforeHookedMethod(param);
                // Hook 到方法执行前，可以在此处理执行一些代码逻辑，一般常用于修改方法传入的参数
                XposedBridge.log("Hook 到 Application.onCreate 执行前");
            }
            @Override
            protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                super.afterHookedMethod(param);
                // Hook 到方法执行后，可以在此处理执行一些代码逻辑，一般常用于修改方法返回参数
                XposedBridge.log("Hook 到 Application.onCreate 执行前");
            }
        });
    }
}

```

* MethodHookParam 类使用介绍

```oxygene
// 当前 Hook 方法的对象实例，如果 Hook 的方法是静态方法就是 null
Object thisObject = param.thisObject;
// 当前 Hook 方法的参数值
Object[] args = param.args;
// 当前 Hook 方法的信息（方法的名称、方法所在类名、方法修饰符、是否为同步方法）
Member method = param.method;
// 获取方法的返回值
Object result = param.getResult();
// 修改方法的返回值
param.setResult(result);
// 判断方法执行是否出现了异常
param.hasThrowable();
// 获取方法调用出现的异常
Throwable throwable = param.getThrowable();
// 修改方法调用出现的异常
param.setThrowable(throwable);
// 返回方法调用的结果，这个结果可能是正常的结果，也可能是一个异常对象
Object resultOrThrowable = param.getResultOrThrowable();

```

* 除了 Hook 方法，Xposed 还提供了其他办法，例如：  
   * XposedHelpers.findAndHookConstructor：Hook 构建函数  
   * XposedHelpers.findField：Hook 字段  
   * ......
* 这些只是 API 调用，这里就不展开细讲了

#### Xposed 实现原理

* 其实这个 Xposed 框架 [wiki](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Frovo89%2FXposedBridge%2Fwiki%2FDevelopment-tutorial%23how-xposed-works "https://github.com/rovo89/XposedBridge/wiki/Development-tutorial#how-xposed-works") 上面已经写了，由于是英文的，大家可能不太好理解，所以这里我跟大家做一下翻译

Android 系统启动时，有一个名为“Zygote”的进程，它是Android运行时的核心。每个应用程序都是作为它的一个副本（“分支”）启动的。当手机启动时，通过/init.rc脚本启动了这个进程。进程的启动是通过/system/bin/app\_process完成的，它加载所需的类并调用初始化方法。

* 每个应用程序启动的时候的，都会通过 Zygote 进程 fork 出来一个新的进程，那么 Zygote 进程是怎么来的呢？当 Android 系统开机时，会通过 `/init.rc` 脚本来开启，Zygote 进程的启动是通过 `/system/bin/app_process` 来完成，在这里会加载所需要的类并进行初始化。
* Xposed 的原理其实很简单，就是搞了一个扩展版的 `app_process`，并进行狸猫换太子，这个扩展版的 `app_process` 会在启动过程中会将 Xposed Jar 包添加到类加载器中，并初始化 [XposedBridge](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Frovo89%2FXposedBridge%2Fblob%2Fmaster%2Fsrc%2Fde%2Frobv%2Fandroid%2Fxposed%2FXposedBridge.java "https://github.com/rovo89/XposedBridge/blob/master/src/de/robv/android/xposed/XposedBridge.java") main 函数入口，main 函数其实就干了两件事  
   1. initNative：初始化钩子，注册方法、字段等监听  
   2. loadModules：加载 xp 模块，就是读取 `assets/xposed_init` 注册的类名，然后进行反射创建和加载
* 涉及到的核心代码有以下这些：

> [XposedBridge#main](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Frovo89%2FXposedBridge%2Fblob%2Fmaster%2Fsrc%2Fde%2Frobv%2Fandroid%2Fxposed%2FXposedBridge.java%23L90 "https://github.com/rovo89/XposedBridge/blob/master/src/de/robv/android/xposed/XposedBridge.java#L90")

```reasonml
public final class XposedBridge {

	@SuppressWarnings("deprecation")
	protected static void main(String[] args) {
		// Initialize the Xposed framework and modules
		try {
			SELinuxHelper.initOnce();
			SELinuxHelper.initForProcess(null);

			runtime = getRuntime();
			if (initNative()) {
				XPOSED_BRIDGE_VERSION = getXposedVersion();
				if (isZygote) {
					startsSystemServer = startsSystemServer();
					initForZygote();
				}

				loadModules();
			} else {
				log("Errors during native Xposed initialization");
			}
		} catch (Throwable t) {
			log("Errors during Xposed initialization");
			log(t);
			disableHooks = true;
		}

		// Call the original startup code
		if (isZygote)
			ZygoteInit.main(args);
		else
			RuntimeInit.main(args);
	}
}

```

> [runtime#InitNativeMethods](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Frovo89%2Fandroid%5Fart%2Fblob%2Fb23f49623aa41ff4acc9b18fcd8b45cdb8493eb6%2Fruntime%2Fruntime.cc%23L1557 "https://github.com/rovo89/android_art/blob/b23f49623aa41ff4acc9b18fcd8b45cdb8493eb6/runtime/runtime.cc#L1557")

```reasonml
void Runtime::InitNativeMethods() {
  VLOG(startup) << "Runtime::InitNativeMethods entering";
  Thread* self = Thread::Current();
  JNIEnv* env = self->GetJniEnv();

  // Must be in the kNative state for calling native methods (JNI_OnLoad code).
  CHECK_EQ(self->GetState(), kNative);

  // First set up JniConstants, which is used by both the runtime's built-in native
  // methods and libcore.
  JniConstants::init(env);

  // Then set up the native methods provided by the runtime itself.
  RegisterRuntimeNativeMethods(env);

  // Initialize classes used in JNI. The initialization requires runtime native
  // methods to be loaded first.
  WellKnownClasses::Init(env);

  // Then set up libjavacore / libopenjdk, which are just a regular JNI libraries with
  // a regular JNI_OnLoad. Most JNI libraries can just use System.loadLibrary, but
  // libcore can't because it's the library that implements System.loadLibrary!
  {
    std::string error_msg;
    if (!java_vm_->LoadNativeLibrary(env, "libjavacore.so", nullptr, nullptr, &error_msg)) {
      LOG(FATAL) << "LoadNativeLibrary failed for \"libjavacore.so\": " << error_msg;
    }
  }
  {
    constexpr const char* kOpenJdkLibrary = kIsDebugBuild
                                                ? "libopenjdkd.so"
                                                : "libopenjdk.so";
    std::string error_msg;
    if (!java_vm_->LoadNativeLibrary(env, kOpenJdkLibrary, nullptr, nullptr, &error_msg)) {
      LOG(FATAL) << "LoadNativeLibrary failed for \"" << kOpenJdkLibrary << "\": " << error_msg;
    }
  }

  // Initialize well known classes that may invoke runtime native methods.
  WellKnownClasses::LateInit(env);

  VLOG(startup) << "Runtime::InitNativeMethods exiting";
}

```

> [runtime#RegisterRuntimeNativeMethods](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Frovo89%2Fandroid%5Fart%2Fblob%2Fb23f49623aa41ff4acc9b18fcd8b45cdb8493eb6%2Fruntime%2Fruntime.cc%23L1557 "https://github.com/rovo89/android_art/blob/b23f49623aa41ff4acc9b18fcd8b45cdb8493eb6/runtime/runtime.cc#L1557")

```reasonml
void Runtime::RegisterRuntimeNativeMethods(JNIEnv* env) {
  register_dalvik_system_DexFile(env);
  register_dalvik_system_VMDebug(env);
  register_dalvik_system_VMRuntime(env);
  register_dalvik_system_VMStack(env);
  register_dalvik_system_ZygoteHooks(env);
  register_java_lang_Class(env);
  register_java_lang_DexCache(env);
  register_java_lang_Object(env);
  register_java_lang_ref_FinalizerReference(env);
  register_java_lang_reflect_AbstractMethod(env);
  register_java_lang_reflect_Array(env);
  register_java_lang_reflect_Constructor(env);
  register_java_lang_reflect_Field(env);
  register_java_lang_reflect_Method(env);
  register_java_lang_reflect_Proxy(env);
  register_java_lang_ref_Reference(env);
  register_java_lang_String(env);
  register_java_lang_StringFactory(env);
  register_java_lang_System(env);
  register_java_lang_Thread(env);
  register_java_lang_Throwable(env);
  register_java_lang_VMClassLoader(env);
  register_java_util_concurrent_atomic_AtomicLong(env);
  register_libcore_util_CharsetUtils(env);
  register_org_apache_harmony_dalvik_ddmc_DdmServer(env);
  register_org_apache_harmony_dalvik_ddmc_DdmVmInternal(env);
  register_sun_misc_Unsafe(env);
}

```

#### Xposed 疑惑解答

##### 使用 Xposed 框架有什么需要注意的点或者坑吗？

* 如果你用的是旧版本的 Android Studio，需要在设置中禁用 Instant Run，否则编译时类不会直接包含在 apk 中，会导致 hook 失败

![](https://proxy-prod.omnivore-image-cache.app/0x0,suIY3CBJzuodCzCXXQYtFFsSju--Ns4hk7b9X0POXbmk/https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a53df99126cd4342a4d576d40015088f~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=1602&h=1102&s=182714&e=png&a=1&b=2d2f32)

###### 项目依赖 Xposed 框架为什么用的是 compileOnly，而不是用 implementation 或者 api？

* 因为没有必要，因为装了 Xposed 模块的系统上面，是存在 Xposed 的调用相关类的，所以没有必要打到包里面去。

###### Hook 了目标应用之后，没有生效该怎么办？

* 出现这种问题大概率是 Xposed 模块晚于目标应用执行，这样就会导致 Hook 不生效，重启一下目标应用即可。

###### Xposed 可以 Hook native 层的方法吗？

* 不行，Xposed 只能用于 Java 层代码的 Hook，目前不支持 Native 层代码的 Hook。

###### Hook 到方法后，当前代码环境是在目标应用的进程中还是 Xposed 应用的进程中？

* 是在目标进程中，而不是在 Xposed 应用进程中，因为 Xposed 模块要依赖目标应用才能生效，本质上是寄生在目标的应用上做监控和修改，所以进程不会独立于目标应用。

###### 在没有装 Xposed 框架的手机运行难道不会崩溃吗？

* 理论上不会的，因为 Xposed 会通过读取 `src/main/assets/xposed_init` 文件中的类名，我们在这个类里面调用 Xposed 的 API，如果用户的手机没有装 Xposed 框架，那么自然也不会去进行这一操作，当然有一种情况除外，如果是通过其他入口的加载的 Hook 类，那就另当别论了。

###### 在项目中使用 `XposedBridge.log` 打印日志和使用 Log 打印日志有什么区别吗？

* 区别在于 XposedBridge.log 打印的日志，不仅可以在 Logcat 控制台看到，也可以在 Xposed 框架上看到，这里以 LSPosed 为例，可以在此处看到。

![](https://proxy-prod.omnivore-image-cache.app/0x0,svDirHkem3c3z75dJM9hjt2S3cG6Q5mTwI_n-ihRjUvI/https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b6dc54f10b3c4b8a92d71f38e455ebae~tplv-k3u1fbpfcp-jj-mark:3024:0:0:0:q75.awebp#?w=868&h=1848&s=195145&e=png&a=1&b=fbfbff)

---

