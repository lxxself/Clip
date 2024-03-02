---
id: cefeadf5-0684-4300-a564-9bc68c5b9326
---

# 我的 Android 应用安全方案梳理 - 掘金
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-18c8b60ccad)
[Read Original](https://juejin.cn/post/7079794266045677575)

作为独立开发者，应用被破解是一件非常让人烦恼的事情。之前有同学在我的一篇博文下面问，有没有一些 Android 防破解的方法。在多次加固、破解、再加固、再破解的过程中，我也积累了一些思路和方法。这里分享一下，如果需要用到，可以作一个参考。

先说一个结论，也是我在 Stackoverflow 上面的一个国外程序员的答案，

![anti_debug.png](https://proxy-prod.omnivore-image-cache.app/0x0,sJKvd_SsBrlBNmLKg64M-3Yxt4bh_VdgXTL5XfS-HRzc/https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ca374875d002437ea2555dbc30116457~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp?)

就是说，APK 包已经在别人手上了，我们能做的不过是提升被破解的难度，如果真的遇到非常“执着”的，要破解一样被破解。如果逻辑非常值钱，那么最好还是把逻辑放到服务器上面。此外，加固也是一个可选的方案。不过目前市面上专业的加固价格并不美丽，各大平台年费从 3 万至 8 万不等，并且对个人开发者并不友好。

下面是我开发过程中为了防止应用被破解采取的一些策略。

## 1、一些必要的基础知识

首先，别人要破解你的软件。如果只是在自己的手机上面使用，那么他可以修改系统的一些方法进行破解。这种不在我的考虑范围内，因为他们的修改只在自己的手机上生效，构不成传播。我关注的是 APK 文件被破解的情况。

我们在加密的时候会用到一些加密或者编码方法。常见的有，非对称加密算法 RSA 等；对称加密算法 DES、3DES 和 AES 等；不可逆的加密 MD5、SHA256 等。

另外，我们会把重要的加密逻辑放到 Native 层来实现，所以一些 JNI 编程的方法也是需要的。不过，如果仅仅是用来作加密的话，对 C/C++ 的要求是没那么高的。对在 Android 中使用 JNI，可以参考我之前的文章[《在 Android 中使用 JNI 的总结》](https://juejin.cn/post/6844903785744039943 "https://juejin.cn/post/6844903785744039943")。

## 2、签名校验

### 2.1 基础签名校验

在应用和 so 中作签名校验可以说是最基本的安全策略。在应用中作签名校验可以防止应用被二次打包。因为如果别人修改你的代码，肯定要重新打包，此时签名必然会改变。对 so 作签名校验是很有必要的，除了防止应用被打包，也可以防止你的 so 被别人盗用。

可以使用如下的代码在 java 中进行签名校验，

```reasonml
private static String getAppSignatureHash(final String packageName, final String algorithm) {
    if (StringUtils.isSpace(packageName)) return "";
    Signature[] signature = getAppSignature(packageName);
    if (signature == null || signature.length <= 0) return "";
    return StringUtils.bytes2HexString(EncryptUtils.hashTemplate(signature[0].toByteArray(), algorithm))
            .replaceAll("(?<=[0-9A-F]{2})[0-9A-F]{2}", ":$0");
}

```

对于在 Native 层作签名校验，将上述方法翻译成对应的 JNI 调用即可，这里就不赘述了。

上面是签名校验的逻辑，看似美好，实际上稍微碰到有点破解的经验的就顶不住了。我之前遇到的一种破解上述签名校验的方法是，在自定义 Application 的 `onCreate()` 方法中读取 APK 的签名并存储到全局变量中，然后 Hook 获取应用签名的方法，并把上述读取到的真实的签名信息返回，以此绕过签名校验逻辑。

### 2.2 Application 类型校验

针对上述这种破解方式，我想到的第一个方法是对当前应用的 Application 类型作校验。因为他们加载 Hook 的逻辑是在自定义的 Application 中完成的，如果他们的 Application 和我们自己的 Application 类路径不一致，那么可以认定应用为破解版。

不过，这种方式作用也有限。我当时采用这种策略是考虑到有的破解者可能就是用一个脚本破解所有应用，所以改动一下可以防止这类破解者。但是，后来我也遇到一些“狠人”。因为我的软件用了 360 加固，所以如果加固壳工程的 Application 也认为是合法的。于是，我就看到了有的破解者在我的加固包之上又做了一层加固...

### 2.3 另一种签名校验方法

上述签名校验容易被 Hook 绕过，我们还可以采用另一种签名校验方法。

记得之前在[《使用 APT 开发组件化框架的若干细节问题》](https://juejin.cn/post/7026341869059571720 "https://juejin.cn/post/7026341869059571720") 这篇文章中提到过，ARouter 在加载 APT 生成的路由信息的时候，一种方式是获取软件的 APK，然后从 APK 的 dex 中获取指定包名下的类文件。那么，我们是不是也可以借鉴这种方式来直接对 APK 进行签名校验呢？

首先，你可以采用下面的方法获取软件的 APK，

```reasonml
ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(), 0);
File sourceApk = new File(applicationInfo.sourceDir);

```

获取 APK 签名信息的方法比较多，这里我提供的是 Android 源码中的打包文件的签名代码，代码位置是：[android.googlesource.com/platform/to…](https://link.juejin.cn/?target=https%3A%2F%2Fandroid.googlesource.com%2Fplatform%2Ftools%2Fapksig%2F%2B%2Fmaster "https://android.googlesource.com/platform/tools/apksig/+/master")

这样，当我们拿到 APK 之后，使用上述方法直接对 APK 的签名信息进行校验即可。

## 3、对重要信息的加密

上述我们提到了一些常用的加密方法，这里介绍下我在设计软件和系统的时候是如何对用户的重要信息作加密处理的。

### 3.1 使用签名字段防止伪造信息

首先，我的应用在做用户鉴权的时候是通过服务器下发的字段来验证的。为了防止服务器返回的信息被篡改以及在本地被用户篡改，我为返回的鉴权信息增加了签名字段。逻辑是这样的，

* 服务器查询用户信息之后根据预定义的规则拼接一个字符串，然后使用 SHA256 算法对拼接后的字符串做不可逆向的加密
* 从服务器拿到用户信息之后会直接丢到 SharedPreference 中（最好加密之后再存储）
* 当需要做用户鉴权的时候，首先根据之前预定义的规则，对签名字段做校验以判断鉴权信息是否给篡改
* 如果鉴权信息被篡改，则默认为普通用户权限

除了上述方法之外，**为服务器配置 SSL 证书**也是比不可少的。现在很多云平台都会提供一年免费的 Trust Asia 的证书（到期可再续费），免费使用即可。

### 3.2 对写入到本地的键值对做处理

为了防止应用的逻辑被破解，当某些重要的信息（比如上面的鉴权信息）写入到本地的时候，除了做上述处理，我对存储到 SharedPreference 中的键也做了一层处理。主要是使用设备 ID 和键名称拼接，做 SHA256 加密之后作为键值对的键。这里的设备 ID 就是 ANDROID\_ID. 虽然 ANDROID\_ID 用作设备 ID 并不可靠，但是在这个场景中它可以保证大部分用户存储到本地的键值对中的键是不同的，也就增加了破解者针对某个键值对进行破解的难度。

### 3.3 重要信息不要直接使用字符串

在代码中直接使用字符串很容易被别人搜索到，一般对于重要的字符串信息，我们可以将其先转换为整数数组。然后再在代码中通过数组得到最终的字符串。比如下面的代码用来将字符串转换为 short 类型的数组，

```angelscript
static short[] getShortsFromBytes(String from) {
    byte[] bytesFrom = from.getBytes();
    int size = bytes.length%2==0 ? bytes.length/2 : bytes.length/2+1;
    short[] shorts = new short[size];
    int i = 0;
    short s = 0;
    for (byte b : bytes) {
        if (i % 2 == 0) {
            s = (short) (b << 8);
        } else {
            s = (short) (s | b);
        }
        shorts[i/2] = s;
        i++;
    }
    return shorts;
}

```

### 3.4 Jetpack 中的数据安全

除了上面的一些方法之外，Android 的 Jetpack 对数据安全开发了 Security 库，适用于运行 Android 6.0 和更高版本的设备。Security 库针对的是 Android 应用中读写文件的安全性。详情可以阅读官方文档相关的内容：

> 更安全地处理数据：[developer.android.com/topic/secur…](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.com%2Ftopic%2Fsecurity%2Fdata "https://developer.android.com/topic/security/data")

## 4、增强混淆字典

混淆之后可以让别人反编译我们的代码之后阅读起来更加困难。这在一定程度上可以增强应用的安全性。默认的混淆字典是 `abc` 等英文字母组成，还是具有一定的可读性的。我们可以通过配置混淆字典进一步增加阅读的难度：使用特殊符号、`0oO` 这种相近的字符甚至 java 的关键字来增加阅读的难度。配置的方式是，

```ldif
# 方法名等混淆指定配置
-obfuscationdictionary dict.txt
# 类名混淆指定配置
-classobfuscationdictionary dict.txt
# 包名混淆指定配置
-packageobfuscationdictionary dict.txt

```

一般来说，当我们自定义混淆字典的时候需要从下面两个方面呢考虑，

1. 混淆字典增加反编译识别难度使代码可读性变差
2. 减小方法和字段名长度从而减小包体积

对于 `o0O` 这种虽然可读性变差了，但是代码长度相比于默认混淆字典要长一些，这会增加我们应用的包体积。我在选择混淆字典的时候使用的是比较难以记忆的字符。我把混淆字典放到了 Github 上面，需要的可以自取，

> 混淆字典：[github.com/Shouheng88/…](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2FShouheng88%2FLeafNote-Community%2Fblob%2Fmain%2Fdict.txt "https://github.com/Shouheng88/LeafNote-Community/blob/main/dict.txt")

下面是混淆之后的效果，

![QQ截图20220216230706.png](https://proxy-prod.omnivore-image-cache.app/0x0,ssLA84GT1WQme8y17Ii40_AdbH40HfA5gemgK--X90tI/https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d075c60ce5a04acb90ffa752270dd7e9~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp?)

这既可以保证包体积不会增大，又增加了阅读的难度。不过当我们反混淆的时候可能会遇到反混淆乱码的问题，比如 SDK 默认的反混淆工具就有这个问题（工具本身的问题）。

## 5、so 安全性

对 so 的破解，我现在也没有特别好的方法。之前我已经**把一些需要高级权限的逻辑搬到了 native 层**，但是最终一样被破解。如果是专业的加固，会对 so 同时做加固。我个人目前对 so 也不是特别熟，之前被破解也是因为 so 的内容被修改。后面会对 so 相关的内容做进一步学习和补充。上面提到的 so 的签名校验可以作为安全性检查之一，下面还有一些开发过程中的其他建议可以做参考。

### 5.1 不要使用布尔类型作为重要 native 方法的返回类型

使用布尔类型作为 native 方法的返回值的一个不好的地方是，别人破解起来会非常容易。因为对于布尔类型，它只有 true 和 false 两种情况。所以，破解者可以很容易地通过将类地方法修改为直接返回 true 或者 false 来绕开校验的逻辑。相对来收更好的方式是返回一个整数或者字符串。

### 5.2 校验方法的 native 特性

如果一个方法是 native 方法，我们可以通过判断方法的属性信息来判断这个方法是否被修改。上面提到了有些 native 方法如果直接返回布尔类型，可能直接会被篡改为直接返回 `true`/`false` 的形式。此时，破解者就把 native 方法修改为普通的方法。所以，我们可以通过判断方法的 native 特性，来判断这个方法是否被别人做了手脚。下面是一个示例方法，

```oxygene
val method = cls.getMethod("method", Int::class.java)
Modifier.isNative(method.modifiers)

```

## 6、不要把校验逻辑封装到一个方法里

把一套逻辑封装成一个方法对于常规业务的开发是一个好的习惯。但是把权限校验的逻辑封装到一个方法中就不一定了。因为别人只要把注意力方法在你的这一个方法上面就足够了。这样，只要破解了这一个方法就可以破解你的应用中所有的安全校验逻辑。

但是如果把同一个权限校验的逻辑在所有需要做权限校验的地方都拷贝一份，后续代码维护起来也会非常困难。那么有没有比较折衷的手段，既可以实现逻辑集中维护，又可以把权限校验的逻辑分散到各个需要做权限校验的地方呢？答案是有，只不过要求应用中使用的是 kotlin 语言。

**使用 inline 实现权限校验集中管理和分散调用**：inline 是 kotlin 的一个关键字，效果类似于 C 语言中的内联。编译的时候会将 inline 方法中的逻辑内联到调用的地方。我们只需要将我们的权限校验的逻辑写到 inline 方法中，然后在需要鉴权的地方调用这个 inline 方法，就可以实现权限校验集中管理和分散调用。这样如果需要破解我们的校验逻辑，需要到每个地方依次进行破解。

此外，

1、**权限校验的逻辑最好和业务代码交织在一起而不是分开写**。原因如上，分开写别人只要破解这一个方法就够了。 2、**C/C++ 层也可以尝试使用 inline 方法**。

## 7、使用服务器做安全校验

上面也说了最好的安全措施还是把重要的逻辑放到后端。不过，对于我开发的应用，因为它本身基本是离线使用的，所以，无法在操作过程中使用服务器做鉴权。对此，我使用了两个方案来让服务器参与到防破解中。

其一是，**启用版本配置，在应用配置中下发强制升级信息**。最初为应用设计服务器的时候我就设计了应用从后端拉取配置信息的接口。这个接口也会同时下发应用的版本信息以及升级的类型。如果是强制升级，那么会弹出一个无法取消的对话框。这样这个版本基本就无法继续使用了。通过这个配置，我们可以通过服务器配置直接禁用被破解的应用版本。

其二，**在执行需要高级权限的操作的时候上报服务器。服务器通过后端存储的用户信息判断该用户是否具备该权限**。如果不具备权限，那么增加一条违规记录，并记录违规用户的用户信息。后台通过可以配置的形式对单一用户进行禁用。至于这里为什么不直接对用户进行禁用的问题。正如《七武士》中的一个桥段一样，好的防守总是会留一个入口。直接禁用很容易被破解者发现并做相应处理。

另外，**最好不要直接抛出异常，弹出的 toast 不要使用明文字符串**。因为，上述两种方式都很容易让别人直接定位到我们校验的逻辑的位置。如果不得不抛异常，建议触发 OOM！

## 总结

写了那么多东西，我也无奈，破解比反破解要容易得多，以上是我在实践过程中总结的一些基本的技巧。对于 Android 应用安全，我还有很多东西需要学习和了解。毕竟，对于应用层开发来说，安全是另一个专业领域的事情。我也只能“防君子不防小人”。后续我学习了更多的内容，做了更多的攻防战，总结更多经验之后再补充。唉，“本是同根生，相煎何太急”！

[![打榜入口](https://proxy-prod.omnivore-image-cache.app/0x0,sYCGjtlz4o45qmaDwoBYJ0UcGY9Wzr-boSDKHg3JBXZo/https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0049b6e0dc824befb29c696e1f8d603b~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.avis#?w=795&h=240&s=135496&e=png&a=1&b=131c48)](https://activity.juejin.cn/rank/2023/writer/3685218704691469?utm%5Fcampaign=annual%5F2023)

本文收录于以下专栏

![cover](https://proxy-prod.omnivore-image-cache.app/0x0,s_zE0F8o3-rRMmAFvZzngyQGpci0PDIOC7saAlpiYp3w/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/15473e255de74de380cdfbc56225cbaf~tplv-k3u1fbpfcp-jj:80:60:0:0:q75.avis)

上一篇

 优雅的 Android 对话框类库封装 xDialog

下一篇

 创造 | 一个强大的 Android 自动化打包脚本

---

