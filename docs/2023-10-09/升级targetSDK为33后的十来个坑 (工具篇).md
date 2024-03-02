---
id: 63011363-8224-456d-9dfd-782e51a5e4c1
---

# 升级targetSDK为33后的十来个坑 (工具篇)
#Omnivore

[Read on Omnivore](https://omnivore.app/me/https-mp-weixin-qq-com-s-bf-7-ck-j-tmj-jrnu-9-xxe-1-qp-g-18b12f9672d)
[Read Original](https://mp.weixin.qq.com/s/Bf7ckJTmjJrnu9Xxe1qp-g)

 Android教授 _2023-10-09 08:00_ _发表于天津_ 

## 一. 事件背景 

若是有和我一样, 要上线Google Play Store的同学, 那你们也应该知道, Google现在要求: "在8月31号之前, targetSDK要升为33"

```undefined
作者：snwrking
```

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sVIfLs1Ru_Dtdlb92J9I1mv3aacMwO1RvseZMO-bZYPE/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNWrAvjJTcJ4Querxf3YM0ibcMWyAgqkTDJ2ANZem1dkIVnV4GODibDMvQ/640?wx_fmt=other)

## 政策改变

以前的政策是:

* 新app, 要求8月31号之前, targetSDK升级到X
* 老app, 要求11月1号之前, targetSDK升级到X

现在的政策则变了, 对于新或老app, 全都一视同仁, 要求在8月31号之前, targetSDK要升到某一版本号. 而且时间就是每年的8月31号了.

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,s6NIShqKRHy33Akd12OKrSV_yJEASHyZi0k08kjd-HL4/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNQCZErpmZshCicZFogyRHfx5m8bMdibIib5mDXbllaia9x4aR3U9xtlWJ0w/640?wx_fmt=other)

因此, 我本来计划是9月进行的升级targetSDK工作, 提前到了7月底开始进行. 也因此碰到了多个坑, 血淋淋的坑, 填这些坑花了两三天时间. 下面分享出来, 毕竟离8月底的deadline已经很近了, 希望本文对有需要的同学有所帮助.

## 万一来不及了?

不要紧张, 去play store console里, 你会有那个policy violation的小横幅弹出来说你没有满足targetSDK = 33的要求.

点击它进入到Policy violation详情页, 在最最下方, 就有"request extension"的按钮, 点击这个按钮, 选好原因 (如"没有时间来做", "已经提交但被拒了", "需要更多时间来更新", ...), 就行了, 这个extension request是**马上**就被批准了.

被批准后就是这样的提示:

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sUViJqZ6yzzNEXYnPUES3P0xxRZt1hcn6gSJvSlN5dR8/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNCFVh1vGa6n6upvTTagoygiaM2lchIichmLcZToH3dsBlN1TSCMTgxolg/640?wx_fmt=other)

这样这个要求就是延期到10月底了, 只要10月底之前做好就行了.

升级targetSDK蛮容易的, 就是去 `app/build.gradle`中把`compileSDK, targetSDK`全升成33就行了.

但其实的工作却要多一些, 要去Android 13 features and chagnes list官网上看各种新加的东西. 比如新加了POST\_NOTIFICATION, 我们app就要动态处理, 不然notification根本不会出来 (当然也不会crash啦); ...

网上关于升级targetSDK到33, 要注意哪些 (如新权限, 新功能, 现有功能的变化), 文章有不少的. 我就不写重复写了. 我当时升级自己工程的代码库主要是参考了这几个文章:

* `文章1 https://zhuanlan.zhihu.com/p/572147515` `文章2 https://www.cnblogs.com/xiaxveliang/p/16821788.html` `文章3 https:` `官网说明1 https:` `官网说明2 ` `https://developer.android.com/about/versions/13/summary`

有了上面5篇文章, 基本上代码库的升级就没问题了. 但其实升级并没有完成, 这种升级targetSDK可能还会引发各种连锁反应. 这些连锁反应是网上少有文章涉及的, 所以才是我这文章的重点

## **3.1 Android Studio (下文简称AS)**

### **背景**

因为讨厌新的logcat格式, 所以我一直呆在android studio bumblebee, 一直都没有升级Android Studio.

### **问题**

升级了targetSDK后, 我发现很多功能没有了. 比如说我新建个xml, 然后在里面输入"id", 一般来说, 是有这样的提示的:

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sJfgo7_PgF_bX4sXh9DPxBk3L1oBy6uEdi6SG1hWgN4A/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeN6SKWsY2rxmkZoRkR3ibFP87LZbGsoeicMhDJLcMic6S17L1uiaibpnqpSVg/640?wx_fmt=other)

或是输入layout\_width后, 有可选值的提示:

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,ssDhhHyFEMJmgU_AuyNF7wjYoq9xzKJ9QNfhzJek9bZU/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeN4siaSs9QFcJ7Rpm6fm0jibWFhtcQtARD62lTc9IlNLuyj5WCoK1sib5vw/640?wx_fmt=other)

现在这些智能提示通通没了. 找了一些资料, 才发现, 是说targetSDK升级了的原因.

于是我把targetSDK从刚升级到的33, 回滚到原来的31\. 果然, 上面这些智能提示全有了.

### **解决**

这下破案了: targetSDK升级导致我的Android Studio BumbleBee不再支持一些功能.

所以若想有更好的开发体验, 我要么降级targetSDK (这一点肯定不行, 因为google不让), 要么就是升级Android Studio.

查看了下AS官网, 发现现在的稳定版已经出到了'长颈鹿'了, 也就是AS Giraffe. 本着'不想每年都折腾这么一下'的想法, 就直接升到最新的稳定版吧. 于是我就下载了AS Giraffe, 并安装成功.

### **后续**

于是潘多拉魔盒打开了, 各种问题接踵而来.

## **3.2 Android Gradle Plugin (下文简称AGP)**

AS的官网上其实已经写明: **升级了AS, 那AGP也要升级!**它们二者的对应关系如下:

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sDeS9DhAIj96hz547rd2fuSRyC89b8JgdEJ4pTuLizOI/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNQ9VbZiaicqSq99oib3rZQkpxZbQeELtlTnpIuRK7t0sDXocbibMbUzsibVA/640?wx_fmt=other)

我原来的AGP版本是4.1, 现在也本着索性就升到最新稳定版的思想, 我就想升到Giraffe支持的最高版本, 也就是AGP 8.1.

手动升级AGP是比较累的, 因为要改的东西很多, 还涉及到从4.1到8.1这么多个版本, 所以手动升级是不可能手动升级的, 这辈子都不可能手动升级的. AS里工具这么多, 说话又好听, 肯定要用AS的工具啊.

工具就在这里: Tools -> AGP Upgrade Assistant...

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sx95Ak4IZQtFvrUY-zgLgZYS6dQexgGfU4bkgfgWHIHg/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeN2nsXbo6gRLTHET3vl2pfXufOPFHYfibQqLMSnAzGbRjQpmrAVxNXZDw/640?wx_fmt=other)

点开来后, 你可以选择, 从当前AGP版本, 升级到哪个版本. 然后点击"Run selected steps"即能自动完成升级了:

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sbESj6raX5Jxb4S9ln6waSanhXnk7PKSd7Y-n0b11QmQ/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNIMuvQSr7OpbibtQvUREEtdraeBZqsmEbIkRgBNrd5fBuNpBf557DnVg/640?wx_fmt=other)

升级成功后样子如下:

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sujz3RvXtVxne7VXp4vR9QLGPyV12j3CkL7I3JHnIzP0/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNeZ4Aia8Gzdw0ATwTVny5TF93eGS410EW9Yj2SGfO56Oj7ic6rE2DgyEg/640?wx_fmt=other)

再看下Git变动记录, 你就知道, 有manifest文件被改动了, 还有多个gradle文件改了. 这要是自己手动来升级AGP怕要累死, 所以还是工具好

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sz7eCEELUGlSITreBFOTdgz-K8VgVnRmdRohnGesctjM/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeN6w9JBKEA9OF9Eb9d6GibZLKtytFfVyo3Wm6dk8LSyGLRjQTfNdluNdQ/640?wx_fmt=other)

现在的根目录下的build.gradle已经是这样的了:

```

```

`plugins {  ` `  // AGP版本` `  id 'com.android.application' version '8.1.0' apply false  ` `  id 'com.android.library' version '8.1.0' apply false  ` `  // Kotlin版本 (没变)` `  id 'org.jetbrains.kotlin.android' version '1.5.31' apply false  ` `}`

```


```

备注: 若有同学对AGP升级了, kotin版本是否要升级有疑问, 请放心, AGP与kotlin二者不相关, 互相独立. 所以升级了AGP, 你的kotlin仍可以呆在1.5 或 1.6 .

\-- 说这一点, 是因为应该有不少同学还在用`kotlin-android-extensions`吧, 这个在kotlin 1.8被remove了. 所以你要是升级到了kotlin 1.8, 那就得对项目进行大幅修改, 全面用`findViewById`或是`ViewBinding`了. 这个kotlin的版本问题, 后面会再讲, 不用担心

### **JDK变化**

要是你碰到什么`android LintModelSeveirty requires Java 61, the current is 55`的问题, 那说明你的JDK不行.

JDK的内部版本如下:

```basic
49 = Java 5 ; 50 = Java 6 ; 51 = Java 7 ; 52 = Java 8
```

```angelscript
53 = Java 9 ; 54 = Java 1055 = Java 11 ; 56 = Java 12 ; 57 = Java 13 ; 58 = Java 14; 59 = Java 15 ; 60 = Java 1661 = Java 17 ; 62 = Java 18 ; 63 = Java 19 ; 64 = Java 20
```

所以这个错误就是说, 你用的是JDK 11, 但需要使用JDK 17才行.

#### **原因**

原因是以前用JDK 11就行, 但自从AGP 8.1开始, 就需要使用JDK 17 (如下图所示).

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sthGTKiCZmACkyjZ-dlUYGupGrjSTKTAFkMI6zi05W0s/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNGUnBkF896Og7dM59lpDHEN8eMwgvWFIXaSYTyfXaH1rYMtf16WGfvw/640?wx_fmt=other)

#### **解决**

要是你下载了新AS, 那直接使用AS内置的JDK就行. 你可以在AS里这样设置, 在`Settings -> Build, Execution, Deployment -> Buiild Tools -> Gradle -> 右侧 Gradke JDK`里选中`jbr-17`即可 (图中的jbr是指jetbrains runtime的意思啦)

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,s6tmRBr1UPZUbHRufRUm6fq7G3r6MN3BMJR9XZED1Zpo/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNOE1njFiankh6EHGvlWjYMQy3GEdgfhmyXicXc2ibIQoenRWcS14V4yXQg/640?wx_fmt=other)

## **3.3 修复各种AGP升级引发的问题**

升级了AGP后, 就引发各种牛鬼蛇神, 下面我就一一简略地说一下如何解决它们.

### java.util.Set错误

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sAg6EMSDx6TDvVPswuYdaPnu6P2jXp3X3uUW4ga5Fut0/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNM4oE4O1V4lE2kiaI3qOxP0snevribemxRgvP4DxQCJqJAPIaSoLoicaeg/640?wx_fmt=other)

按Stackoverflow上的说明, 升级google play service即可

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sTtCzLg7ouaRc_KAbqXAeaeZlUVBBg8tkSiLcrj_bUJs/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNOhz4oUBzSZDk84EM9guarZ0ocXrMUvLOBCbs2SG8YhwkWVGMVriaZug/640?wx_fmt=other)

### Apple Chip问题

要是你用的是Mac的M1, M2芯片, 那你的ROOM可能会在升级后build失败

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sMh5N8AezAXF1qPjnX4N90sjm8G0PlbKq4ldl87TMNvg/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNzSbrxSatXk2ialcBQ4nmb8RiazY00alCEVIaeFibcxaFaSrS5upJZEcUA/640?wx_fmt=other)

解法有多种:

1). 要么升级ROOM到2.4.0以上

2). 要么不用AS自带的JDK 17, 而去Open JDK中下载一个JDK 17, gradle去用这个Open JDK 17

3). 要么就在gradle的依赖里加一句`kapt "org.xerial:sqlite-jdbc:3.34.0"`

这三种方法都可以. 第一种方法就是还要变化一些代码, 因为ROOM的api有点变化. 另外两种方法更简单些.

## **3.4 升级Kotlin与Androidx包**

### **升级Kotlin**

应该有不少同学还在使用`kotlin-android-extensions`这个插件吧, 只要用id就能得到一个view, 很方便的 但是这个插件在Kotlin 1.8中被彻底删除了. 所以现在还不想大规模修复这个问题, 就得保证你的kotlin在1.8版本之下. 比如说: 在1.8之下最高的版本, 即1.7.22

改kotlin版本还是蛮容易的, 去根目录下的build.gradle里修改

```

```

`plugins {  ` `  // AGP版本` `  id 'com.android.application' version '8.1.0' apply false  ` `  id 'com.android.library' version '8.1.0' apply false  ` `  // Kotlin版本 (升级了)` `  id 'org.jetbrains.kotlin.android' version '1.7.22' apply false   //原来是1.5.31` `}`

```


```

升级后会有一些kt文件有些问题, 但这些都是null与non-null的小问题, 修复起来不难.

### **升级androidx**

androidx的几个关键包, 如`core-ktx`, `appcompat`, `activity`, `fragment`, `lifecycle`都是和targetSDK或kotlin版本绑定得很死的. 你要是用了不对的版本, 那就会因为和kotlin不匹配而编译失败.

经过我一一试错, 发现下面的版本是最适合targetSDK = 33的, 再高就要编译失败了:

```undefined
   
```

` // core-ktx 1.9.0与Android 13 (API 33)更兼容;  版本再高如1.10.0就编译出错, 因为它需要kotlin 1.8版本` `    implementation 'androidx.core:core-ktx:1.9.0'` `    //targetSDK = 33后, 可以从1.4.1升到最新的1.6.1` `    implementation 'androidx.appcompat:appcompat:1.6.1'` `    // targetSDK = 33后, 从1.6.0可升到最新的1.9.0.    // 再也没这个编译错误了: "Can't determine type for tag '<macro name="m3_comp_assist_chip_container_shape">?attr/shapeAppearanceCornerSmall</macro>'"` `    implementation 'com.google.android.material:material:1.9.0'` `  
` `    // targetSDK = 33后, 版本不能是最新的1.7.1与1.6.0, 不然会因为kotlin-stdlib要使用1.8而编译不能` `    implementation "androidx.activity:activity-ktx:1.5.0"` `    implementation "androidx.fragment:fragment-ktx:1.5.0"` `  
` `    // targetSDK = 33后, 不能高到2.6去, 不然会因为kotlin-stdlib要使用1.8而编译不能` `    def lifecycle_version = "2.5.1"` `    implementation "androidx.lifecycle:lifecycle-viewmodel-ktx:$lifecycle_version"` `    implementation "androidx.lifecycle:lifecycle-livedata-ktx:$lifecycle_version"` `    implementation "androidx.lifecycle:lifecycle-runtime-ktx:$lifecycle_version"` `    implementation "androidx.lifecycle:lifecycle-viewmodel-savedstate:$lifecycle_version"` `    implementation "androidx.lifecycle:lifecycle-reactivestreams-ktx:$lifecycle_version"` `    implementation "androidx.lifecycle:lifecycle-common-java8:$lifecycle_version"` `    implementation "androidx.lifecycle:lifecycle-process:$lifecycle_version"` `  
`

**小细节**

另外请注意, 若你以前用了`lifecycle-extensions`包, 那现在这个包没了![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sr2s6FTmSXo403Bnf-GVURGdjHcDchxa8I0TRnlxoHfQ/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNX7FSArM2gymke3H50571nAqZeGUq7YXLXMdPhoRVAC1Xt6MNuckTAg/640?wx_fmt=other)这个`lifecycle-extensions`包里的内容分散到了独立的更小的包里了, 如以前在`lifecycle-extensions`包里的ProcessLifecycleOwner类, 现在已经在` implementation "androidx.lifecycle:lifecycle-process:$lifecycle_version"`包里了.

## **3.5 CircleCI新问题**

### **打debug包失败**

经过上面几步, 我在本地打debug包都没问题了. 但到了CI/CD上 (我们公司用的是CircleCI), 结果出现打包失败

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sKoCUPlHKbcoHfM1fEvOUQjgE1UyDDQwokU5oyUUFhOU/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNtJiaQBsghK04yaZxABKiaERpZiaNo01d3HqDAU4sq3dBnjNtNw0RaVYicw/640?wx_fmt=other)

查了好久, 发现网上说的

1). 设置executor

```

```

`executors:` `  java17:` `    docker:` `      - image: 'cimg/openjdk:17.0'`

```


```

2). 自己下载jdk 17

```

```

`steps:  ` `    - checkout  ` `    - run:  ` `        name: Install OpenJDK 17  ` `        command: |  ` `            sudo apt-get update && sudo apt-get install openjdk-17-jdk  ` `            sudo update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java  ` `            sudo update-alternatives --set javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac  ` `            java -version`

```


```

这两个方法全都没用, 不能解决"不能打包"的问题

接着查, 才知道原来CircleCI的docker镜像是有设置JAVA\_HOME的, 如`android:2023.07`中就使用了JDK17的JAVA\_HOME环境变量的.

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sLN2JAltOc3LM0svazMVKewyVo0eanB7pszQh-iJCVpo/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNO1gTD1PeYguAdthjk9MoFw3zDZyMuWhnhbzSrYPYRhZ3GM6mFU94ZA/640?wx_fmt=other)

所以解决办法就是就是升级android image:

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sWZE4fPI1Nklz0jowHnHBuEtzXYAj8eBSEkAT4NmB9WA/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNFG6ibad1Kt9FVmtibtnwvT8ryCWrz0csficm1QgVK6ctp4k1MkdziayovQ/640?wx_fmt=other)

结果就是经过了上面的修复后, build debug apk成功!

### **打release包失败**

但后来又发现, 打release包竟然又失败了. 好在这次的失败, AGP帮我们搞出了原因:

```

```

`> Task :app:minifyStagingReleaseWithR8  ` `> ERROR: Missing classes detected while running R8.  ` `   Please add the missing classes or apply additional keep rules  ` `   that are generated in /home/circleci/repo/xxx/build/xxx/mapping/stagingRelease/missing_rules.txt.  ` `> ERROR: R8: Missing class com.abc.camera.hardware.VersionInterval  ` `   (referenced from: com.abc.hardware.Version com.abc.internal.DeviceInfo.mEglVersions and 4 other contexts)` `  
`

这下AGP帮我们指出了哪些新规则需要添加, 我们把这个`missing_rules.txt`文件中的内容, 添加到自己项目里的`proguard-rules.pro`文件中就行了.

```

```

`# Please add these rules to your existing keep rules in order to suppress warnings.` `# This is generated automatically by the Android Gradle plugin.` `-dontwarn com.abc.hardware.VersionInterval` `-dontwarn com.abc.internal.DeviceInfo.mEglVersions` `-dontwarn com.abc.internal.client.ClientCallback`

```


```

果然, 现在打release包也成功了

## 四. release包的crash 

上面经过修改后, CircleCI打一个release包是没问题了, 但是打出来的包一打开来就crash.

## **4.1 Androidx Navigation库的问题**

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,s11d1rW_SgoxFJ42Hw4VFthGzbYy8yNCJ1ta46OFqiGQ/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNoiapF5tmCBdjKlZgfIUqoic5iaq0cZrLqaiahUCv01qDibZl2UgoZdflyRQ/640?wx_fmt=other)

因为debug包运行没有crash, 所以肯定不是navigation库自己的问题, 应该是minify这里出了问题.

果然, 找了下网络, 虽然有很多说要自己加这个`@Navigator.Name`注解到Navigator子类里, 但关键在于我们代码里根本没有重写Navigator啊, 那这个crash到底是什么?

其实就是minify这里, 让一些navigation的东西不要混淆即可. 所以去proguard文件中添加

```

```

`# java.lang.IllegalArgumentException: No @Navigator.Name annotation found for m` `-keepattributes RuntimeVisibleAnnotations  ` `-keep class * extends androidx.navigation.Navigator`

```


```

那app就能打开了

## **4.2 网络请求后crash**

app虽然打开了, 但只要有网络请求就会再次crash. 同样也是debug中没这问题, 所以肯定也是类似proguard的问题.

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sjwkdHTbL2WRIOPKKuv_jgt23RKlCR3eK8aQlxflu0BI/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNoaFHGYdQ00H1b7vnsiazrFc6397ksuMIDEDgplO2YJV3OWJJgRUkibmA/640?wx_fmt=other)以及:

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sqGlQXQce9_LdH-bBVE7gyj-t2cHYc2V_BYDll-FUhCU/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW8FR8ibTwbWsb35zPwuIvOeNTHjIPzgk7hWlrsyGqLmF6Z1HnCmBcu9ibLQBONic0icyoj0KgvcmGSasQ/640?wx_fmt=other)

我查了下, 我用的是Retrofit 2.9, 已经是最新版本, 所以更新版本来解决问题的思路是不行了.

那我就去Retrofit官网查了下, 果然Square早就给出了答案, 说R8的编译会有点特别, 所以要加入以下proguard rule即可:

```

```

`# With R8 full mode, it sees no subtypes of Retrofit interfaces since they are created with a Proxy` `# and replaces all potential values with null. Explicitly keeping the interfaces prevents this.` `-if interface * { @retrofit2.http.* <methods>; }` `-keep,allowobfuscation interface <1>` `  
` `# Keep inherited services.` `-if interface * { @retrofit2.http.* <methods>; }` `-keep,allowobfuscation interface * extends <1>` `  
` `# With R8 full mode generic signatures are stripped for classes that are not` `# kept. Suspend functions are wrapped in continuations where the type argument` `# is used.` `-keep,allowobfuscation,allowshrinking class kotlin.coroutines.Continuation` `  
` `# R8 full mode strips generic signatures from return types if not kept.` `-if interface * { @retrofit2.http.* public *** *(...); }` `-keep,allowoptimization,allowshrinking,allowobfuscation class <3>` `  
`

**4.3 本节小总结**

因为debug包运行起来没问题, 只有release包运行起来才crash, 所以肯定是release包里有的, debug包里没有的东西, 导致了这次crash, 比如说: shrinkResource, 或是 proguard.

果然, 这几次全是在proguard这里出问题了.

## 五. 总结 

原来以为简单的升级targetSDK, 结果发现连带着还要把AS, AGP, JDK, Kotlin, Androidx, Google Play Service, ...这些东东一一升级一下. 而且还碰到了好多稀奇古怪的错误, 跟我们代码无关的错误, 整个的修复过程还是很累人的.

希望我踩过并填了的坑的经验, 能帮到更多的人吧, 毕竟8月31号就要到了, 要升级的怕是时间也不多了.

关注我获取更多知识或者投稿

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sDONE7-7LBDc4dFSE7Jwt7TpioYkmHxw2rWwB8zb6Bk4/https://mmbiz.qpic.cn/sz_mmbiz_jpg/Gb5lsYBRibteO7I5LTnJiaYGdAC8Hcr1Z2adg0lV9vcSbGx0BA9g8icPTRStq7ct7ATYhD79v1csy6tObgesrhtUA/640?wx_fmt=jpeg)

![图片](https://proxy-prod.omnivore-image-cache.app/0x0,sEqUAbS07-kMGB3Ii1Pewa1gyKeCCIjHWO2VHkHwlOuA/https://mmbiz.qpic.cn/mmbiz_jpg/yyLvy204xW9Uibw4qQxibOBKL1DicLX10o3gibpbVwAGtDUV15FZianjGs1whAZ2gg71IV6J7zQpQhtQRcSyHrGJbxg/640?wx_fmt=jpeg)

---

