---
id: 5243a66b-029d-4cbf-9ad5-2805fee1e668
---

# 我将自定义 ClassLoader 的坑都踩了一遍
#Omnivore

[Read on Omnivore](https://omnivore.app/me/class-loader-1818b18b598)
[Read Original](https://mp.weixin.qq.com/s?__biz=MzA5MzI3NjE2MA%3D%3D&amp%3Bchksm=8863203fbf14a9297b4ff41dcbb7c081475fc6d90097212340fcbf66fd445c409038cbce29a5&amp%3Bidx=1&amp%3Bmid=2650263888&amp%3Bmpshare=1&amp%3Bscene=1&amp%3Bsharer_shareid=a1c1a089a599c63559b93d9e0110f8ff&amp%3Bsharer_sharetime=1653366889049&amp%3Bsn=1f4f7cfb5659296f5530a72db872df28&amp%3Bsrcid=0524UdEFOEs1p1zaKT4SC5JL)

 Zuo  郭霖 _发表于江苏_ 

  
/ 今日科技快讯 /

近日，为回应美国制裁，俄罗斯外交部21日公布了一份永久禁止入境的美国人名单，共有963人。不出意料，美国总统拜登及其儿子亨特拜登榜上有名。

这一近千人的永久禁止入境“黑名单”范围广泛，包括拜登政府成员、国会议员、科技高管、记者、普通美国公民，其中甚至包括著名黑人演员摩根弗里曼以及2018年去世的前参议员麦凯恩。不过，这份名单并未包括前总统特朗普。

/ 作者简介 /  

本篇文章来自Zuo的投稿，文章主要分享了如何将自定义 ClassLoader 的坑都踩了一遍，相信会对大家有所帮助！同时也感谢作者贡献的精彩文章。

Zuo的博客地址：

> https://juejin.cn/user/747323635537159

/ 前言 /

JAVA 虚拟机与实现语言解绑，与Class 文件字节码这种特定形式的二进制文件格式 相关联。在类加载阶段，虚拟机会通过类的全限定名来获取该类的二进制流，再将该二进制流所代表的静态存储结构转换为方法区的运行时数据结构，最后在内存中生成一个代表这个类的 java.lang.Class 对象，作为方法区内该类的各数据访问入口。

说白了就是，虚拟机不关心我们的这种“特定二进制流”从哪里来的，从本地加载也好，从网上下载的也罢，都没关系。虚拟机要做的就是将该二进制流写在自己的内存中并生成相应的Class对象（并不是在堆中）。在这个阶段，我们能够通过我们自定义的类加载器来控制二进制流的获取方式。

/ 编译class /

我简单写了一个 Test.java 类，并将该文件放于桌面：

\[/Users/zuomingjie/Desktop/Test.java\]

package com.blog.a;  
public class Test {  
    public String getTestStr() {  
        return "hello world";  
    }  
}                         

通过 javac 命令，编译 .class 文件，于桌面上：

其中 -d 用来生成 package 目录结构，com.blog.a为包名：

为什么要将 class 文件放在包结构目录下呢？这就跟下面的全限定名有关。

/ MyClassLoader /

来编写我们的 ClassLoader 类，并重写 loadclass 和 findclass 方法：

loadclass 方法，要注意调用 parent.load 接口，因为 Object 等系统类还是需要通过双亲委派模式来让父加载器加载的。

findClass 拿到 class 字节码，这里就是普通的 IO 操作读取 class 文件，就不贴代码了，最后使用 defineClass 来生成目标 Class 对象。

我们的调用代码，通过 MyClassLoader 来加载 Test.class 二进制文件，并生成 Class 对象，容易出错的地方，就是这个 filePath 和 name 值了。

运行结果，可以使用 AS 的 JavaTest:

/ URLClassLoader /

我们也可以直接使用系统提供的 URLClassLoader 来加载本地 class 文件，其内部实际也是通过重写 findClass 方法并调用 defineClass 来实现的：

运行结果，可以使用 AS 的 JavaTest。

刚刚的例子都是在 java 环境下的，我们想下，如果我们要在 App 内加载一个外部的 Class 文件呢？

/ App加载Class /

说干就干，首先我通过 adb push 命令，将 Test.class push 到设备的本地路径 /sdcard/com/blog/a 下：

我直接在 onCreate 中调用上文的加载方法，代码就不贴了，具体见上，注意 path 为设备根目录，直接运行：

结果报错，告诉我们不支持外部加载 class 文件，为啥呢？这就是 Java 虚拟机 和 Android 虚拟机不一样的地方了，Android 系统定制了 Java 虚拟机，原生的 Java 虚拟机运行的是 class 文件，而 Android 虚拟机是直接运行dex文件的。

我在之前的文章说过：

1. aapt2 编译res/文件，生成编译后的二进制资源文件（.ap\_文件）、R.java文件。
2. Javac 工具，会将 R.java、.java文件、Aidl 接口文件编译成 .class 文件
3. R8 又会将上一步产生的 .class 文件和第三方依赖中的 .class文件编译成 .dex 文件
4. apkbuilder 将编译后的资源（.ap\_文件）、dex文件及其他资源文件(例如：so文件、asset文件等)，压缩成一个 .apk 文件

我们就试着加载下 dex 文件呗？

/ App加载dex /

**编译class文件**

说干就干，首先将 Test.class 文件编译成 jar 文件于桌面上，可以通过 jar 命令：

一定要注意路径，这样写是错误的，这样会生成一个Users.zuomingjie.Desktop.com.blog.a 的错误包名的 jar 文件。正确写法应该是，先 cd 到 Users.zuomingjie.Desktop 路径下，再执行 jar 命令：

运行结果：

**编译dex文件**

我们再将 test.jar 编译成 dex 文件，可以通过 dx 命令：

dx 是 sdk 自带的工具，如果命令找不到，需要将 dx 路径添加到全局变量内，其目录在：/sdk/build-tools/{版本号}/。ok，执行命令。

执行结果：

加载前，可以先将 test.dex push 到设备 /sdcard/blog 路径下：

**加载dex**

我们知道，一个 App 最少是有两个 ClassLoader 的，一个是 BootClassLoader ，一个是 PathClassLoader，前者负责加载 framwork class 系统类，后者负责加载应用中的类。其中 BootClassLoader 是 PathClassLoader 的 parent，注意这里的 parent 并不是父类，而是双亲委派模型的一种上层关系。

private static ClassLoader createSystemClassLoader() {  
    String classPath = System.getProperty("java.class.path", ".");  
    String librarySearchPath = System.getProperty("java.library.path", "");  
    return new PathClassLoader(classPath, librarySearchPath, BootClassLoader.getInstance());  
}                  

注意：PathClassLoader 只能加载已安装的 APK 的 dex 文件，我们实际用来加载外部 dex 文件的 ClassLoader 是 DexClassLoader。

public DexClassLoader(String dexPath, String optimizedDirectory, String librarySearchPath, ClassLoader parent)               

* dexPath：dex 文件的路径
* optimizedDirectory：dex 的加压路径，一般在 data/{package name}/xxx 路径
* librarySearchPath：目标类中所使用的native库存放的路径
* dexClassLoader：dexClassLoader 的父加载器，一般为当前的类加载器

DexClassLoader 的使用方法也很简单，下面来加载 test.dex。

运行结果：

现在我在主工程内，即在主dex 新增一个同限定名的 Test 类：

package com.blog.a;  
public class Test {  
    public String getTestStr() {  
        return "hello APK dex";  
    }  
}         

我再调用 DexClassLoader：

直接运行，不出所料：

但这里你没有疑惑吗？为啥能够强转？不是说不同 classLoader 加载的同限定名类，就是不同类吗？哈哈，结论是对的，但因为代码里 parent = getClassLoader()，而根据双亲委派模型，DexClassLoader 在 loadClass 时会首先使用 parent 装载器加载，所以默认会先从 base.apk 中加载 com.blog.a.Test，所以这里强转并没有问题。

**优先加载dex**

现在通过类名，获取 Test.class，并执行内部方法：

执行结果，发现是使用的主dex 的类：

如果我想优先使用 test.dex 类内的方法呢，要怎么搞？

通过查看 DexClassLoader 源码，代码就不全贴了，findClass 后会调用到 DexPathList 的 findClass 方法，在这里会遍历 dexElements，dexElements 内部为 Element(file)，即我们 dex 文件信息。

但是 DexPathList 是被每个 ClassLoader 分别持有的，如果将 DexClassLoader 的 dexFile name 也添加在 PathhClassLoader 的集合首位是不是就 ok 了呢？

答案是肯定的，亲测有效。

实现也很简单，直接通过反射，先拿到每个 ClassLoader 各自的 dexElements 集合：

之后进行合并，test.dex 放在 base.dex 前面：

最后重新复值：

我们打印下 PathhClassLoader 新的集合内容：

运行结果：

现在再通过类名，获取 Test.class，执行其方法试下呢：

运行结果，发现已经变了，会优先执行 test.dex 文件：

**思考**

有两点需要思考下：

* 如果 test.dex 文件中使用了资源，我们能调用吗？
* 如果 test.dex 文件中使用了四大组件，我们能启动组件吗？

答案都是否定的。

那为啥使用了资源，我们就没法调用了呢？我们知道在 APK 构建过程中，aapt 会编译资源文件，生成二进制资源文件（.ap\_文件）和 R.java文件，这些在编译期间就已经完成了，所以我们动态加载的 dex 文件内的资源肯定是找不到的。

为啥四大组件也不行呢？因为每个组件都要在 Manifest 文件中注册，而 Manifest 文件会在 APK 安装的时候，会被系统 PMS 读取并记录，而安装完后， PMS 就不会再去重新读取 Manifest 文件了，所以 dex 文件内组件因为没有被注册而导致无法启动。

那就没法解决吗？肯定不是，后面会介绍 Android 的插件化技术。

* 资源加载，AssetManager.addAssetPath
* 四大组件支持，Hook 和静态代理

推荐阅读：

[我的新书，《第一行代码 第3版》已出版！](http://mp.weixin.qq.com/s?%5F%5Fbiz=MzA5MzI3NjE2MA==&mid=2650248955&idx=1&sn=0c5237154c4c8de2ca635f8a578aa701&chksm=88636794bf14ee823e8c11854b5c014e49a4af425c2947e7c62f3ce139062b5560b4c44e3d4f&scene=21#wechat%5Fredirect)  

[我为Android版Microsoft Edge所带来的变化](http://mp.weixin.qq.com/s?%5F%5Fbiz=MzA5MzI3NjE2MA==&mid=2650263700&idx=1&sn=5d5b9fd8d155ac1d04cfb2c4cbbfce77&chksm=886321fbbf14a8edb565af4fd79eb64c7822ae0bced32d745598064756b31ffb19e3438182ce&scene=21#wechat%5Fredirect)  

[一个解决滑动冲突的新思路，无缝嵌套滑动](http://mp.weixin.qq.com/s?%5F%5Fbiz=MzA5MzI3NjE2MA==&mid=2650263545&idx=1&sn=50ab0a558ff77be6779c86496d6dfc91&chksm=88633e96bf14b7808dfa6fee8501dae95ad4bf32eef0285f15b43491597e5f19bd738fb5b95d&scene=21#wechat%5Fredirect)  

欢迎关注我的公众号

学习技术或投稿

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,s4oUv0EiXcT20OmoYqZS2HEIbakAy7Mit2JoS19pTfQw/https://mmbiz.qpic.cn/mmbiz/wyice8kFQhf4Mm0CFWFnXy6KtFpy8UlvN0DOM3fqc64fjEj9tw23yYSqujQjSQoU1rC0vicL9Mf0X6EMR4gFluJw/640.png?wx_fmt=png)

长按上图，识别图中二维码即可关注

阅读原文

---

## Highlights

> 结果报错，告诉我们不支持外部加载 class 文件，为啥呢？这就是 Java 虚拟机 和 Android 虚拟机不一样的地方了，Android 系统定制了 Java 虚拟机，原生的 Java 虚拟机运行的是 class 文件，而 Android 虚拟机是直接运行dex文件的。 [⤴️](https://omnivore.app/me/class-loader-1818b18b598#4975c587-c885-46c0-ae3b-cd5f9abc8af8) 

> 如果 test.dex 文件中使用了资源，我们能调用吗？
> 如果 test.dex 文件中使用了四大组件，我们能启动组件吗？ [⤴️](https://omnivore.app/me/class-loader-1818b18b598#56eb64cf-6f3c-4704-be01-b2001d7a098e) 

> 资源加载，AssetManager.addAssetPath
> 四大组件支持，Hook 和静态代理 [⤴️](https://omnivore.app/me/class-loader-1818b18b598#660412a7-e319-4398-adfb-f22115f0a728) 

