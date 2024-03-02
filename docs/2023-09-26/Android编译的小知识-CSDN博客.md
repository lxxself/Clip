---
id: b839b93c-5871-406d-abdf-fe64804cc294
---

# Android编译的小知识-CSDN博客
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-csdn-18acf69bfb8)
[Read Original](https://blog.csdn.net/eclipsexys/article/details/133053703)

![](https://proxy-prod.omnivore-image-cache.app/0x0,sb9FtdCb_T4b1O697eqoXY9k3NVVgRsw8SlTyVuCA3pc/https://csdnimg.cn/release/blogv2/dist/pc/img/original.png)

 版权声明：本文为博主原创文章，遵循[ CC 4.0 BY-SA ](http://creativecommons.org/licenses/by-sa/4.0/)版权协议，转载请附上原文出处链接和本声明。

### 背景

Android是如何进行编译的？ 项目中的源代码是如何一步步被执行为可以安装到手机上的apk的？ 文章会一一给大家介绍，尽量以代码为例，好让大家快速理解。

> 文末有福利\~

### 1\. 认识Gradle

#### 1.1 Gradle简介

官方文档：https://docs.gradle.org/7.3.3/userguide/what\_is\_gradle.html 官方解释：Gradle是一个开源的自动化构建工具。 现在Android项目构建编译都是通过Gradle进行的，Gradle的版本在gradle/wrapper/gradle-wrapper.properties下 ![07b62be31487a646f7a1e1d0fe26bf17.png](https://proxy-prod.omnivore-image-cache.app/0x0,sF1BH0ep8RMaPXStsYli--9wnrbuu0Tpn_5pQ5U3Px_8/https://img-blog.csdnimg.cn/img_convert/07b62be31487a646f7a1e1d0fe26bf17.png) Gradle版本为7.3.3 当我们执行assembleDebug/assembleRelease编译命令的时候，Gradle就会开始进行编译构建流程。 当然，在此之前，我们得先了解下Gradle的生命周期

#### 1.2 Gradle生命周期

![4184351cdd4189b94a688cd413bd8e3b.png](https://proxy-prod.omnivore-image-cache.app/0x0,sDrMu89_VvwrSVhjTbTZ61kMUeGBmUoQsa-CvMBOgv-0/https://img-blog.csdnimg.cn/img_convert/4184351cdd4189b94a688cd413bd8e3b.png) 初始化阶段 执行项目根目录下的settings.gradle脚本，用于判断哪些项目需要被构建，并且为对应项目创建Project对象。 Configuration配置阶段 配置阶段的任务是执行各module下的build.gradle脚本，从而完成Project的配置，并且构造Task任务依赖关系图以便在执行阶段按照依赖关系执行Task。这个阶段Gradle会拉取remote repo的依赖（如果本地之前没有下载过依赖的话） ![15c50cd05ce3e9d065647c1b8024003e.png](https://proxy-prod.omnivore-image-cache.app/0x0,sSSNVQJnkSCHy_c5Cp6y6LcNvoIValS2r0ZkOyQmiz9o/https://img-blog.csdnimg.cn/img_convert/15c50cd05ce3e9d065647c1b8024003e.png) gradle cache一般是放在.gradle/caches/modules-2/ 目录下 ![b8ec714e530130fe8445348e61ec478d.png](https://proxy-prod.omnivore-image-cache.app/0x0,sbOMh540i0ZAImcVPajjTAcvvw9KvDQ426Ae32vSrjMA/https://img-blog.csdnimg.cn/img_convert/b8ec714e530130fe8445348e61ec478d.png) Execution执行阶段 获得 Task 的有向无环图之后，执行阶段就是根据依赖关系依次执行 Task 动作。 执行阶段的log如下（一般以Task + module名+task名称） ![17470f73efa8eb8256ec8e593f196b1f.png](https://proxy-prod.omnivore-image-cache.app/0x0,sGuGRttSg4K-AokYaaGStiH457WBaKqw7FytoE-OLKTU/https://img-blog.csdnimg.cn/img_convert/17470f73efa8eb8256ec8e593f196b1f.png)

### 2\. 认识AGP

#### 简介

AGP即Android Gradle Plugin，主要用于管理Android编译相关的Gradle插件集合，包括javac，kotlinc，aapt打包资源，D8/R8等都是在AGP中的。 AGP的版本是在根目录的build.gradle中引入的 ![43224dc5a9d4616c607c93e7efefd44e.png](https://proxy-prod.omnivore-image-cache.app/0x0,s-rwfV5RxAHXoKho0cjhRMjaDwg-Vn-mmnl0AZo94x8U/https://img-blog.csdnimg.cn/img_convert/43224dc5a9d4616c607c93e7efefd44e.png) 如图所示AGP版本为7.2.2

#### AGP与Gradle的区别与关联

首先需要声明的是，AGP与Gradle不能直接划“等号”，二者不是一个维度的，Gradle是构建工具，而AGP是管理Android编译的插件，是一群java程序的集合。 可以理解为AGP是Gradle构建流程中重要的一环。 虽然AGP与Gradle不是一个维度的事情，但是二者也在一定程度上有所关联 ：二者的版本号必须匹配上 https://developer.android.com/studio/releases/gradle-plugin?hl=zh-cn#updating-gradle ![d359dffd4ad4ad3ca3ce008640a96931.png](https://proxy-prod.omnivore-image-cache.app/0x0,soVf3_aZ30cccOpYPDnFbjHU8N9YAYA7Kr5eFMYIOBmw/https://img-blog.csdnimg.cn/img_convert/d359dffd4ad4ad3ca3ce008640a96931.png) 当前AGP版本7.2.2，Gradle版本7.3.3，是符合这个标准的。 ps：既然Android编译是通过AGP实现的，AGP就是Gradle插件，那么这个插件是什么时候被apply的呢？因为一个插件如果没有apply的话，那么压根不会执行的。 ![7d381d2001044aa127117975ed5f6267.png](https://proxy-prod.omnivore-image-cache.app/0x0,sfHXdP0YW7Q8ttNKJyR_sB8lmf_qfcxs9LzeItqmDLNk/https://img-blog.csdnimg.cn/img_convert/7d381d2001044aa127117975ed5f6267.png) 这就是AGP被apply的地方，也是区分一个module究竟是被打包成app还是一个library

### 3\. AGP和Gradle的一些使用trick

#### 生成Gradle编译报告

编译的时候通过加上--scan，可以生成在线报告。 例如./gradlew assembleDebug --scan 1）基于这个报告，我们可以分析编译耗时的task ![d5480cf97d93f4d988c4390720108296.png](https://proxy-prod.omnivore-image-cache.app/0x0,sWsghuYGde_KdwpZrD8gC6sAEq3c0R19Kt_UwWneOeS4/https://img-blog.csdnimg.cn/img_convert/d5480cf97d93f4d988c4390720108296.png) 2）分析依赖情况（当然本地也可以） ![3f4852d7b51d7379b76844a0cdcbd622.png](https://proxy-prod.omnivore-image-cache.app/0x0,sPgRT-pORWyUssJxdezhHHn1cczLoa0MAVK5pXvPgeOc/https://img-blog.csdnimg.cn/img_convert/3f4852d7b51d7379b76844a0cdcbd622.png) 可以知道具体被打包进apk的aar版本究竟是哪个 3）分析引入的依赖对应的maven地址（可以删除废弃的maven，或者确定maven的优先级引入顺序，让编译提速） ![ec261d4002b31b3849afb145b8ce5d6c.png](https://proxy-prod.omnivore-image-cache.app/0x0,sPi61w0j36Dacr6Z83u6mnOF5Ekt8DdGCFYGy2rzJxKw/https://img-blog.csdnimg.cn/img_convert/ec261d4002b31b3849afb145b8ce5d6c.png) 例如kotlin插件就是放在远端仓库： https://repo.maven.apache.org/maven2/ 4）结合AGP源码分析每个阶段执行的具体task ![572cabe0459209664e971bb9db2accd2.png](https://proxy-prod.omnivore-image-cache.app/0x0,sjo59fajRddqgbMxxeDxXXJ5gcQro6TVCMU7gpXxYYLk/https://img-blog.csdnimg.cn/img_convert/572cabe0459209664e971bb9db2accd2.png) dexBuilderTESTDevDebug是在AGP的DexArchiveBuilderTask这个阶段执行的

#### AGP源码查看与调试

##### 源码查看

可以通过在项目中加上compileOnly "com.android.tools.build:gradle:7.2.2" 即可查看AGP7.2.2的源码。 例如如果要查看dexbuilder阶段的源码，通过上述图片中的task名称“DexArchiveBuilderTask”直接全局搜索即可 ![2e8e39bf8d017b38c73bd93012eda2d2.png](https://proxy-prod.omnivore-image-cache.app/0x0,sptf92umYyb5jnuj6ZyKy48DZaaBg7GMd19cIOzrEWQg/https://img-blog.csdnimg.cn/img_convert/2e8e39bf8d017b38c73bd93012eda2d2.png) 这样我们就能知道Android究竟是如何一步步进行编译的。

##### AGP断点调试

当然，光知道源码在哪是不够的，想清楚知道AGP的每个执行细节，需要有能够调试的手段，所以AGP的调试手段就很有必要了。后续AGP都以7.2.2为准 步骤

1. Menu → Run → Edit Configurations → Add New Configuration → Remote ![e7ddc8241dae3542d3bffc83caaccd5e.png](https://proxy-prod.omnivore-image-cache.app/0x0,sbrJnBgEFgh4Nku7vyEB0Uj63-MfB8YjaQaac0KIH1zY/https://img-blog.csdnimg.cn/img_convert/e7ddc8241dae3542d3bffc83caaccd5e.png) 点击apply即可
2. 选择要调试的位置，例如我这里调试dexbuilder，打上断点 ![15e100a8959d57a7eff5fd67a42d146e.png](https://proxy-prod.omnivore-image-cache.app/0x0,slJ8M3bcAUFXDzGfzADPLQ4dW5Eax5EAt1f_s5ZUQaaI/https://img-blog.csdnimg.cn/img_convert/15e100a8959d57a7eff5fd67a42d146e.png)
3. terminal中输入 ./gradlew assembleDebug -Dorg.gradle.daemon=false -Dorg.gradle.debug=true
4. 此时编译会卡住，切换到刚刚创建的remote，点击调试按钮即可 ![4a8132c93701fec0c1c7c720fbf1ebf1.png](https://proxy-prod.omnivore-image-cache.app/0x0,s3NLLLScJz3F5o3nDIkayT_U67AFCgRsnSCVBptixdro/https://img-blog.csdnimg.cn/img_convert/4a8132c93701fec0c1c7c720fbf1ebf1.png)
5. 等待编译一段时间后，执行到dexbuilder阶段，此时断点会触发，如下 ![7525210b7b8e44d1371569ea16d20e79.png](https://proxy-prod.omnivore-image-cache.app/0x0,sy96X99DyAvOKtj8RhjS0jUsXKmyuNFvxBlwwAnNVuns/https://img-blog.csdnimg.cn/img_convert/7525210b7b8e44d1371569ea16d20e79.png) 后续的话即可一步步调试每个执行逻辑了，对于熟悉AGP源码很有帮助。 ps：以此类推，想调试三方或者自定义Gradle插件也是类似的步骤

![c1b674b12bad0885e7c9cf9737ce943d.png](https://proxy-prod.omnivore-image-cache.app/0x0,s084TCsyD0QeomM8bhMRSz8kxjxZrLDgroD4poUUXKT0/https://img-blog.csdnimg.cn/img_convert/c1b674b12bad0885e7c9cf9737ce943d.png)

#### 资源文件编译

通过aapt2编译工程中的资源文件，包括2部分：

1. 编译：将res目录下的所有文件，AndroidManifest.xml编译成二进制文件
2. 链接：合并所有已经编译的文件，生成R.java和resource.arsc

#### AIDL文件编译

将项目中aidl文件编译为java文件

#### Java与Kotlin文件编译

通过Javac和Kotlinc将项目中的java代码，kotlin代码编译生成.class字节码文件 这里有个问题：

1. 当java，kotlin混编的时候，谁会先编译成class字节码，这个顺序是随机的吗？ 回复：当java，kotlin混编的时候，先执行kotlinc将kotlin文件编译成class字节码，再执行javac将java文件编译成class字节码。
2. 为什么kc比javac先执行？ 回复：kotlin是jetBrains开发的，后续才被确认为Android的官方语言之一。kotlin语言解码器是会兼容java语法的，但是在此之前Java是不认识Kotlin这个语言的，Java唯一认准的是字节码格式，即class文件。所以Kotlin必须先被编译成Java能够识别的class文件，这样Javac才能顺利执行。

#### Class文件打包成Dex

这一步是将生成的class文件和三方库中的aar/jar一并打包成dex 在AGP3.0.1之前，是通过dx将class文件打包成dex 在AGP3.0.1之后，d8替代dx将class文件打包成dex 在AGP3.0.4之后，新增R8（7\. 0 及之后版本的 AGP 强制开启 R8），整合了desugaring、shrinking、obfuscating、optimizing 和 dexing，从而将class文件打包成dex ps:R8是Proguard替代工具，用于代码压缩和混淆，包括以下： ![4383d5e0a447844fe4ad7293b65d7411.png](https://proxy-prod.omnivore-image-cache.app/0x0,szGPD2SGT1UI5QtcTxPDZOW5397RO-a8WiI7D-u0qD34/https://img-blog.csdnimg.cn/img_convert/4383d5e0a447844fe4ad7293b65d7411.png)

1. shrink：摇树优化，去除无用的类、方法、域等代码
2. optimize：对字节码的优化，如删除未使用的参数，内联一些方法等
3. obfuscate：对类、方法的名字进行混淆，使用更短更无规律的字符替代名字
4. preverify：对字节码进行校验，是 ProGuard 对前面所有优化的一个正确性校验

##### 题外话

从这一步可以看到三方库的二进制文件是不会参与javac/kotlinc的编译打包流程的。 这就会引入另一个问题：编译没问题可以正常执行打包成apk，运行时却出现crash了，报这个class/method/field找不到的问题，例如线上常见的“NoClassDefFoundError/NoSuchMethodError/NoSuchFieldError” ![f15f3ea52674a7e451d094c0913f92ac.png](https://proxy-prod.omnivore-image-cache.app/0x0,sCIQKujr3hfSCn9gylz0VPdjHkfsVpeNskryQhXDlLoo/https://img-blog.csdnimg.cn/img_convert/f15f3ea52674a7e451d094c0913f92ac.png) 简单描述下这类问题的本质，以NoSuchMethodError为例 ![41194202e22f916a63ce2e499fc2b456.png](https://proxy-prod.omnivore-image-cache.app/0x0,sL69ECjUVDYd_FRcagcmOmib-opYNPeAreo3Euw4eBWU/https://img-blog.csdnimg.cn/img_convert/41194202e22f916a63ce2e499fc2b456.png) 目前有4个包，分别是:A, B, C:0.0.1, C:0.0.2 其中A依赖C:0.0.1, 01版本C中有funX，funY 2个接口方法 B依赖C:0.0.2, 02版本C中仅有funY 1个接口方法 A，B单独编译都没问题，但是如果A，B被引入到app module中就有问题了 ![8e42778c36486e7378dbd4d9197284d2.png](https://proxy-prod.omnivore-image-cache.app/0x0,s_0jxOOAgeBWS-R3St52UZGniS4ImAbN_00-MZJgkb60/https://img-blog.csdnimg.cn/img_convert/8e42778c36486e7378dbd4d9197284d2.png) 这个时候，A，B，C都是二进制形式，不会参与javac/kotlinc编译，而AGP解决依赖冲突默认以高版本为准。所以最终打包进apk的是：A，B，C:0.0.2 这三个库。 当运行时，如果逻辑刚好走到A库中，刚好要调用C中的funX方法，那么是肯定找不到的，最终会导致NoClassDefFoundError/NoSuchMethodError/NoSuchFieldError 这类错误。

#### 生成APK文件

在资源文件与代码文件都编译完成后，将manifest文件、resources文件、dex文件、assets文件等等打包成一个压缩包，也就是apk文件。在AGP3.6.0之后，使用zipflinger作为默认打包工具来构建APK，以提高构建速度。

#### 签名&对齐

签名：生成apk文件后需要对其签名，否则无法安装 对齐：zipalign会对apk中未压缩的数据进行4字节对齐，对齐的主要过程是将APK包中所有的资源文件距离文件起始偏移为4字节整数倍，对齐后就可以使用mmap函数读取文件，可以像读取内存一样对普通文件进行操作。 注意：如果是用Android的apksinger进行签名，尤其是以V2之后的签名方式，一定是先进行签名，再进行对齐。不过现在基本已经将签名和对齐整合到一起了 原因：V2之后，会往apk中插入签名块，这也是为什么对齐操作只能在签名之后 https://source.android.com/docs/security/features/apksigning/v2?hl=zh-cn ![f5a20af74d64ee133f8610724923e140.png](https://proxy-prod.omnivore-image-cache.app/0x0,sGKbaacn42n5jXNn4v-WMq2PjxTUtZ-Bbnmgek272Fac/https://img-blog.csdnimg.cn/img_convert/f5a20af74d64ee133f8610724923e140.png)

### 5\. 修改编译结果的几种方式

熟悉了编译流程后，我们可以基于AGP，做一些自定义操作，用于修改编译后最终的产物。 中间产物一般在app模块下的build/intermediates下 ![48324a076ab59a811e4279d73c367334.png](https://proxy-prod.omnivore-image-cache.app/0x0,sdzHVWBn-JvjryhJZ4ckfeHYV5FknoaGXkveb2DGpn8g/https://img-blog.csdnimg.cn/img_convert/48324a076ab59a811e4279d73c367334.png)

#### 一、Transform修改字节码

简介 Transform API 是 AGP 1.5 就引入的特性，主要用于在 Android 构建过程中，在 Class→Dex 这个节点修改 Class 字节码。利用 Transform API，我们可以拿到所有参与构建的 Class 字节码文件，借助 Javassist 或 ASM 等字节码编辑框架进行修改，插入自定义逻辑。 ![18f1807982682d3b1542c3a810fe2357.png](https://proxy-prod.omnivore-image-cache.app/0x0,scAfW566hbogtlUOUgFVpR8H3SSqffZDlEnt1WqKNr0A/https://img-blog.csdnimg.cn/img_convert/18f1807982682d3b1542c3a810fe2357.png) 还是以Demo为例，引入字节的btrace插件 ![6cd9dbe04558169011c42f05fb796f99.png](https://proxy-prod.omnivore-image-cache.app/0x0,sSmSEr4am5CMJl8D5LIYr4-zIe0CKEkF3OAl2nfMqSWo/https://img-blog.csdnimg.cn/img_convert/6cd9dbe04558169011c42f05fb796f99.png) 查看开启bTrace后，反编译的apk产物 ![fd6bb2fa23f6c790d1a41dbd9654b867.png](https://proxy-prod.omnivore-image-cache.app/0x0,sWwPAEeC1LDS2sWHrcf05guEWfxUwAjeL1MgXsWrECTM/https://img-blog.csdnimg.cn/img_convert/fd6bb2fa23f6c790d1a41dbd9654b867.png) 他会在每个方法的开始和末尾插入一段代码，用于记录方法节点，以用于运行时trace采集 实际的源码是肯定没有这些代码的 ![d49131d0182dc1650492080822f3d87b.png](https://proxy-prod.omnivore-image-cache.app/0x0,s8MOQE_ar5AtPGsyYn8hb3tkcOrgxe0nZECq4q3JpzKs/https://img-blog.csdnimg.cn/img_convert/d49131d0182dc1650492080822f3d87b.png) 这也让开发面临了一个不得不接受的事实：你写的代码可能并不是apk最终会执行的代码，有可能你的代码，会被某个优化插件给删除或者“魔改” 当排查线上问题的时候，分析堆栈，查看源码并不是唯一手段，有的时候可能需要借助编译产物来具体分析。

##### ASM

说到Transform，就不得不提字节码增强处理框架ASM（此处不展开Javassit知识点）。 ASM是一个通用的Java字节码操作和分析框架，它可用于修改现有类或直接以二进制形式动态生成类。 ASM提供了非常多的回调，用于处理Class字节码的每一行代码。 ![f4f6dc9cc4b4fdc38df821c5821655a4.png](https://proxy-prod.omnivore-image-cache.app/0x0,s5kSSKYhqkioHdM_oRITQ75lMfAdgTZL0sBtsJ275exg/https://img-blog.csdnimg.cn/img_convert/f4f6dc9cc4b4fdc38df821c5821655a4.png) 很多Transform插件都是基于ASM实现的，例如刚刚举例子的bTrace 如果对ASM感兴趣，可以参考下ASM中文指南 https://blog.csdn.net/wanxiaoderen/article/details/106898567 或者原版guide https://asm.ow2.io/asm4-guide.pdf 建议搭配插件工具ASM ByteCode Viewer ![1a57db84be255fb3d001d641a38ee14f.png](https://proxy-prod.omnivore-image-cache.app/0x0,sUUMpO8hSV-T4fJNlFVg1BNrMvti7OiGzaV-PvOyvkZU/https://img-blog.csdnimg.cn/img_convert/1a57db84be255fb3d001d641a38ee14f.png) 这样能对ASM更快上手，当然也需要对Java字节码有比较深入的了解 例如一段简单的代码，在ASM框架下，可能就是这样的 ![95e92810d0b4bb273e23a8f873986e3e.png](https://proxy-prod.omnivore-image-cache.app/0x0,slvV830SrtKw4X5-BksYkThM0jAFmEbVUdwyHurlNMYs/https://img-blog.csdnimg.cn/img_convert/95e92810d0b4bb273e23a8f873986e3e.png)

#### 二、 Gradle Task修改

可以基于Gradle Task，新增自定义task，修改中间产物以达到最终目的 来看一个例子 ![477377215e8f72193c6fc00d45a6bb80.png](https://proxy-prod.omnivore-image-cache.app/0x0,sOt1q43jOh9vTXhjZCCo3M7z-M4d40FiLtfOogx42Mmk/https://img-blog.csdnimg.cn/img_convert/477377215e8f72193c6fc00d45a6bb80.png) 这里就是基于gradle注册了一个新的task，在dexbuilder阶段将输出“register suceess”日志 ![1c9e82819e03d98ef86ed146b759c586.png](https://proxy-prod.omnivore-image-cache.app/0x0,sjqc2DMjz3t5qP_H1cYO5GfQiHQvCpH5FcfyzKX0PLBI/https://img-blog.csdnimg.cn/img_convert/1c9e82819e03d98ef86ed146b759c586.png)

#### 三、 “修改”AGP源码

这里并不是真的修改AGP源码，而是基于类加载机制，如果出现同名的文件，那么会优先加载使用。基于这个原理，我们可以在 classpath "com.android.tools.build:gradle:${agp\_version}" 声明的上方引入我们自定义的同名AGP文件jar，这样当实际运行的时候会优先执行我们自定义的逻辑。 demo演示： 以AGP的processDebugManifestForPackage流程为准 ![f67eb05b4b807f5f5efc534c5da74e13.png](https://proxy-prod.omnivore-image-cache.app/0x0,sExGF-A3TWhKqNO8gZrjtKnaBn2N_K0VhMTcWqbFUjPQ/https://img-blog.csdnimg.cn/img_convert/f67eb05b4b807f5f5efc534c5da74e13.png) 创建AGP中同名的Task文件：ProcessPackagedManifestTask.kt，代码也一并copy ![28c4e3b7fc92596cf5e12fcca4461eba.png](https://proxy-prod.omnivore-image-cache.app/0x0,sMi0w47OkZpHtpaX2YSvGh7PHCOMo5YIhVSs2FwqIvgk/https://img-blog.csdnimg.cn/img_convert/28c4e3b7fc92596cf5e12fcca4461eba.png) 然后在这个文件基础上修改，例如我这里是在对应的task中加了一行日志代码 ![352076e6e8a2a2e06162ae3a3d2831ea.png](https://proxy-prod.omnivore-image-cache.app/0x0,sBjW4gxt4cclHdzEdSn3_em1OAHvUmVfkXYI_Yk2CkkI/https://img-blog.csdnimg.cn/img_convert/352076e6e8a2a2e06162ae3a3d2831ea.png) 发布jar，然后在build:gradle之前引入path ![85199c9215c439997fdc131639b2899a.png](https://proxy-prod.omnivore-image-cache.app/0x0,sW-w0JnfqLfGd-9DECbQrtHjT_jaLArn7qhqyeJZ9GeE/https://img-blog.csdnimg.cn/img_convert/85199c9215c439997fdc131639b2899a.png) 编译app，查看编译日志，发现“替换“成功。 ![f6b3dc243a5a9e21dac8552527811e4a.png](https://proxy-prod.omnivore-image-cache.app/0x0,szPOcsO661dvy12x9fpbVDyQDmxD-sdtZJaWYyRuS0mo/https://img-blog.csdnimg.cn/img_convert/f6b3dc243a5a9e21dac8552527811e4a.png) 基于此，我们对AGP的“替换/修改”的方案已实现。 有了这个实现依据，AGP再也不是Gradle的AGP，而是可以私人定制的，想对AGP的任意task流程做修改都是可以的！

#### 总结

以上三种修改编译结果的方式，适用的场景和优缺点还是不同的 \*\*Transform：\*\*适用于会修改class字节码和处理少量资源的场景。 \*\*优点：\*\*灵活，对字节码的修改没有限制，适用于静态检测，字节码插桩，编译优化，包体优化等相关场景。 \*\*缺点：\*\*学习成本高，需要对ASM（Javassist），class文件结构，字节码处理有一定了解；大部分transform会对编译耗时产生影响；AGP8.0废弃了Transform api接口，适配成本巨大。 \*\*Gradle Task：\*\*适用于对编译产物资源进行简单的修改 \*\*优点：\*\*轻便，完全基于Gradle，例如对AndroidManifest修改，收集中间产物上报等。 \*\*缺点：\*\*无法修改字节码，处理场景并不灵活 \*\*“修改”AGP：\*\*适用于解决AGP版本之间不兼容的问题 \*\*优点：\*\*可以达到直接修改“AGP”行为的方式 \*\*缺点：\*\*需要兼容每个版本，不够灵活，对开发完全黑盒，容易产生潜在的问题。

### 内推招聘帖

\[上海/北京\] 小红书 - 社区客户端团队 - 基础体验技术方向 - iOS/Android

#### 岗位及团队介绍

小红书社区客户端-基础体验技术团队负责小红书社区主站核心业务的研发工作，包括首页主框架、全场景搜索业务、图文笔记业务、视频消费等核心场景的业务探索、性能体验优化、用户体验与架构优化等工作，你可以充分参与到业务的讨论和落地，也可以发挥主观能动性为小红书的发展助力，我们希望你积极主动，热爱移动端产品的研发，愿意深入钻研，提倡提效，反对内卷，做正确、艰难而有价值的事。

#### 岗位要求

##### Android 开发工程师

大学本科或以上学历，计算机相关专业，3年以上 Android 相关经验 对移动研发充满热情，有较强的学习能力，好奇心和积极向上的心态 熟悉 Java/Kotlin 语言，熟悉 Android 系统 API，RxJava，Dagger2，以及 App 打包，测试，开发流程 代码基本功扎实，对数据结构及算法有一定程度的理解，良好的面向对象化编程思想，熟练运用常见设计模式 抗压能力强，具备良好的沟通表达能力和团队合作精神 有大型业务架构设计经验者优先，有跨端、动态化经验者优先

##### iOS 开发工程师

大学本科或以上学历，计算机相关专业，3年以上 iOS 相关经验 对移动研发充满热情，有较强的学习能力，好奇心和积极向上的心态 熟悉 Objective-C/Swift，熟悉 Cocoa 设计模式，深入理解 MVC MVVM 代码基本功扎实，对于常见的第三方库的使用和原理有一定的理解。对数据结构及算法有一定程度的理解，良好的面向对象化编程思想，熟练运用常见设计模式 抗压能力强，具备良好的沟通表达能力和团队合作精神 有大型业务架构设计经验者优先，有跨端、动态化经验者优先

联系方式 邮箱：\[dkong@xiaohongshu.com\] 联系人：扶摇 微信：bridge\_k（加微信备注下公司+岗位+名字+工作经验）秒级通过 优势：Leader直招，秒级反馈，全程跟进，经验分享

  

---

## Highlights

> 例如./gradlew assembleDebug --scan 1） [⤴️](https://omnivore.app/me/android-csdn-18acf69bfb8#b9d6c1a1-1c6f-43ca-8953-081d50f5348c) 

> \*\*Transform：\*\*适用于会修改class字节码和处理少量资源的场景。 \*\*优点：\*\*灵活，对字节码的修改没有限制，适用于静态检测，字节码插桩，编译优化，包体优化等相关场景。 \*\*缺点：\*\*学习成本高，需要对ASM（Javassist），class文件结构，字节码处理有一定了解；大部分transform会对编译耗时产生影响；AGP8.0废弃了Transform api接口，适配成本巨大。 \*\*Gradle Task：\*\*适用于对编译产物资源进行简单的修改 \*\*优点：\*\*轻便，完全基于Gradle，例如对AndroidManifest修改，收集中间产物上报等。 \*\*缺点：\*\*无法修改字节码，处理场景并不灵活 \*\*“修改”AGP：\*\*适用于解决AGP版本之间不兼容的问题 \*\*优点：\*\*可以达到直接修改“AGP”行为的方式 \*\*缺点：\*\*需要兼容每个版本，不够灵活，对开发完全黑盒，容易产生潜在的问题。 [⤴️](https://omnivore.app/me/android-csdn-18acf69bfb8#d571ca65-a6be-48e2-b9e6-79813cc48419) 

