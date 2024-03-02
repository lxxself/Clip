---
id: f22ecfbd-3aae-4b09-84e2-248fed1fb7f7
---

# Android 折叠屏技术发展与适配 - 掘金
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-18ad5b7e467)
[Read Original](https://juejin.cn/post/7049705037525680164)

\[toc\]

## 1 折叠屏行业概览

## 1.1 折叠屏诞生的背景

**手机屏幕**目前的整体发展趋势是**大屏化**，大屏化主要表现在两方面：**屏幕面积**的增大，**屏占比**的提高。但是目前这两方面已经发展的相当成熟，很难再有大的突破。

### 1.1.1 屏幕面积变化

手机由功能手机向智能手机演变最重要的标志是屏幕的变化。2010年智能手机的平均屏幕尺寸仅有3.1英寸，发展至2014年智能手机的屏幕平均尺寸增加至4.8英寸，2018年更是增加至5.9英寸，目前主流的大屏尺寸已达到6.5寸左右，智能手机逐渐朝着大屏化方向发展。

单从屏幕面积来看，6.5英寸左右已是**单手操控**和**携带便捷性**的极限。

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,sZ-bZy0UMMiXqqXXlXnn1oZyOI7gezAj2oWXeFiO3H8I/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cdcea4d9214d4900b0414b6ccaab3cdf~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

### 1.1.2 屏占比变化

手机厂商通过陆续推出**刘海屏**、**水滴屏**、**挖孔屏**、**全面屏**、**升降式摄像头**、**屏下指纹识别**等功能，将屏幕可用面积利用到了极致，极大的提升了屏占比。现阶段大多数手机的屏占比处于\*\*90%\*\*左右，很难再有大的提升空间。

**折叠屏手机**的出现不仅实现了**屏幕尺寸增加**，同时还满足**携带方便**的需求，有效解决大屏和便携矛盾，未来或将成为手机发展的重要方向之一。

## 1.2 折叠屏手机结构

### 1.2.1 折叠屏手机物理结构

折叠屏的主要结构由**柔性AMOLED屏**与**铰链**组成。

通常，我们见到的折叠屏手机都是由1整块AMOLED屏组成，并且铰链位置可以显示画面。

除此之外，目前市面还有一种**双屏手机**（屏幕由2块组成，铰链区域不可显示画面），也被称为折叠屏手机，即微软2020年9月推出的基于Android 10.0系统的Surface Duo。

### 1.2.2 折叠屏手机分类

目前折叠屏的折叠方式主要由以下4种，主流的实现方式是：**横向内折**与**横向外折**

1. **横向内折**：折弯半径小，需使用寿命更高的柔性屏幕，因此实现难度大、技术成本更高。但优点是折叠状态下，屏幕被折合在内侧，可较好保护屏幕。代表产品有：三星Galaxy Fold 和 W20 5G、华为Mate X2、小米MIX Fold；
2. **横向外折**：显示更便捷，但折叠时屏幕在外侧，易损坏。横向外折折叠屏手机价格通常比横向内折价格低，代表产品有：华为 Mate X 和 Mate Xs；
3. **竖向内折**：展开时手机大小与传统智能手机相差不大，折叠后体 积变小，方便携带。代表产品有三星 Galaxy Z Flip、摩托罗拉Moto Raz；
4. **折三折**：需用到两个铰链，成本较高，尚处于概念机阶段。

![](https://proxy-prod.omnivore-image-cache.app/0x0,s19C10A4kjzxLCaUTXcmHvZbv0nzOokbOR3PWBMF7Bls/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6ac20d59d9144180bf2b4db31a5544f2~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

数据来源：[头豹研究院：2020年中国折叠屏手机行业概览](https://link.juejin.cn/?target=https%3A%2F%2Fpdf.dfcfw.com%2Fpdf%2FH3%5FAP202009301418359688%5F1.pdf%3F1601471874000.pdf "https://pdf.dfcfw.com/pdf/H3_AP202009301418359688_1.pdf?1601471874000.pdf")

## 1.3 折叠屏手机市场规模

2020国内智能手机销量约**3亿**部，而同期全球的折叠屏手机出货量仅**194.73 万**部，三星以\*\*71.59%**的市场份额占据全球折叠屏市场第一，华为市场份额**10.56%\*\*位居第二。

从销量来说，折叠屏市场占有依然比较小众，主要原因在于折叠屏手机目前良品率还不够高，产能受限，进而导致手机售价过高；同时，软件方面，大部分软件还未进行完全适配，影响用户体验。

### 1.3.1 限制折叠屏发展因素

1. **技术成熟度低**  
   1. 硬件：屏幕的可靠性、电池续航、铰链设计、屏幕厚度 …  
   2. 软件：应用适配程度较低
2. **良品率低**  
柔性AMOLED比LCD良率低。华为Mate X 的AMOLED屏供应商为京东方，京东方折叠屏目前的良品率数据仅为：2018，65%；2021，85%
3. **价格制约销量**  
当前市场高端机定位6k；折叠屏初期产品普遍售价1w以上，目前部分产品最低售价刚降到万元内。

### 1.3.2 为什么要支持大屏设备

2021 Google I/O 上发布的折叠屏适配新方案，代表Android对折叠屏设备适配的重视，在大屏化的趋势下，折叠屏未来可期。

只要应用适配了折叠屏设备，同时就自动适配了Android 平板等大屏设备。

根据Google发布的数据，通过适配 Android 大屏设备，开发者们可以覆盖超过 2.5 亿台活跃的可折叠设备、平板电脑和 Chromebook。2020 年，平板电脑设备的销售量增长了 16%。分析师预计，到 2023 年市面上将有超过 4 亿台 Android 平板电脑，到2023年可折叠设备销量将达到**3000**万台，增长空间巨大。另外，可折叠设备也正在重新定义高端设备。Android 应用也可以在 Chrome OS 上运行，而 Chrome OS 现在是世界第二大桌面操作系统。

## 2 折叠屏适配方案发展

折叠屏手机适配主要经历了三个重要阶段。

1. **折叠屏手机首次发布，Android官方折叠屏适配指南**  
2018年8月Google发布Android 9.0，首次支持折叠屏功能，并推出了[Android官方折叠屏适配指南](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fguide%2Ftopics%2Fui%2Ffoldables%3Fhl%3Dzh-cn "https://developer.android.google.cn/guide/topics/ui/foldables?hl=zh-cn")。主要从以下几个方面进行适配：  
   1. 应用连续性：处理配置变更  
   2. 屏幕兼容性：`resizeableActivity` 与 `maxAspectRatio`  
   3. 多窗口适配：多项恢复与专属资源访问
2. **厂商补充适配方案**  
各厂商陆续发布自己的折叠屏手机，以及补充的适配方案。不同折叠屏手机上，拥有各自研发的一些独有功能，要想体验这些独特功能，就需要使用厂商的方案进行适配。  
代表：三星、华为、Microsoft Surface Duo等。
3. **Google 2021 I/O 发布`Jetpack WindowManager`等库**  
2021年5月，Google I/O开发者大会推出专门用于折叠屏适配的库 `Jetpack WindowManager` 1.0，以及更新了已有的一些库如：`SlidingPaneLayout`、`NavRail`等，以便应用更便捷的适配折叠屏功能。  
   1. 新增 `Jetpack WindowManager` 1.0，专门用于适配折叠屏手机，获取折叠屏相关信息。  
   2. 更新 `SlidingPaneLayout` 1.2，支持双窗格布局。  
   3. 更新 `NavRail`，实现垂直导航栏。

## 3 Android 官方折叠屏适配指南

主要参考 [官方文档](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fguide%2Ftopics%2Fui%2Ffoldables%3Fhl%3Dzh-cn "https://developer.android.google.cn/guide/topics/ui/foldables?hl=zh-cn")

## 3.1 应用连续性：处理配置变更

在默认情况下，当屏幕发生了变化（这里指折叠屏折叠变化时，或应用从一个屏幕转到另一个屏幕），系统会销毁并重新创建整个 `Activity`。

但我们希望屏幕变化之后，程序能够以切换前的状态继续运行，不需要重启页面。我们可以给 `Activity` 添加`configChanges`配置：

```routeros
<activity
          ...
          android:configChanges="smallestScreenSize|screenSize|screenLayout" />

```

应用内监听变化，根据当前窗口大小，调整布局大小和位置

```kotlin
override fun onConfigurationChanged(newConfig: Configuration) {
		// 获取当前窗口配置信息，调整布局大小
}

```

如果需要重启 `Activity`才能完成适配的场景，可以通过`onSaveInstanceState()`与`onRestoreInstanceState()` 或 `ViewModel对象`来进行之前状态保存和后续的恢复。

更多详细适配参考官方：[保存界面状态](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Ftopic%2Flibraries%2Farchitecture%2Fsaving-states%3Fhl%3Dzh-cn "https://developer.android.google.cn/topic/libraries/architecture/saving-states?hl=zh-cn") 和 [支持配置变更](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fguide%2Ftopics%2Fresources%2Fruntime-changes%3Fhl%3Dzh-cn "https://developer.android.google.cn/guide/topics/resources/runtime-changes?hl=zh-cn")。

## 3.2 屏幕兼容性

[屏幕兼容性](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fguide%2Fpractices%2Fscreens%5Fsupport "https://developer.android.google.cn/guide/practices/screens_support")

### 3.2.1 应用大小可调：resizeableActivity

`resizeableActivity` 用于声明是否支持**多窗口模式**和**动态调整显示尺寸**。

折叠屏时，需要让应用支持动态改变尺寸，我们需要在 menifest 中的 `Application` 或对应的 `Activity` 下声明属性：

```avrasm
android:resizeableActivity="true"

```

* 当系统编译设置`target` \>= **24（Android 7.0）** 不需要手动设置，系统默认为 `true`，支持多窗口和调节尺寸。
* 如果应用设置 `resizeableActivity=false`，则会告知平台其不支持多窗口模式。系统可能仍会调整应用的大小或将其置于多窗口模式；但要实现兼容性，便需要对应用中的所有组件（包括应用的所有 Activity、Service 等）应用同一配置。在某些情况下，重大变更（例如，显示屏尺寸更改）可能会重启进程，而不会更改配置。这时需要支持折叠屏连续性（不重启`Activity`），添加属性  
```haskell  
<meta-data  
    android:name="android.supports_size_changes" android:value="true" />  
```
* 若Activity 设置了 `resizableActivity=false` 以及 `maxAspectRatio`。设备展开时，系统会将应用置于兼容模式，以此保持 Activity 配置、大小和宽高比。

![](https://proxy-prod.omnivore-image-cache.app/0x0,s8Y3ajo68L1SJtQVD6xaE5dio5pH9vYEuQAdZB-K1t7M/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1e08ab4e809b4c9097112c29e7c8a8e6~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

### 3.2.2 新的屏幕宽高比：maxAspectRatio（可选）

当`resizeableActivity=false`声明不支持多窗口时，使用[maxAspectRatio](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fguide%2Ftopics%2Fmanifest%2Factivity-element%3Fhl%3Dzh-cn%23maxaspectratio "https://developer.android.google.cn/guide/topics/manifest/activity-element?hl=zh-cn#maxaspectratio")、[minAspectRatio](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Freference%2Fandroid%2FR.attr%3Fhl%3Dzh-cn%23minAspectRatio "https://developer.android.google.cn/reference/android/R.attr?hl=zh-cn#minAspectRatio") 指定最小或最大纵横比，在设置的纵横比限制范围内，折叠屏情况下，会自动对尺寸进行调节，超出限制的进入兼容模式（黑边）。

为支持折叠屏，Android 系统增加了21:9（2.33，三星 Glaxy Fold 屏幕比例） 超大纵横比。

推荐纵横比设置范围：\[1, 2.4\]，即1:1到12:5

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,sVzl6ijxyO6umbNeOKfQqpFWKfkNVuwP1ZKHtcWll9Zo/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1bc6f6058a08428abb8abc2b303e7d8a~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

而当`resizableActivity=true`时设置`maxAspectRatio` 等无效

更多信息参考 [官方文档：声明受限屏幕支持](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fguide%2Fpractices%2Fscreens-distribution.html "https://developer.android.google.cn/guide/practices/screens-distribution.html")

## 3.3 多窗口支持

更多多窗口功能参考：[多窗口支持](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fguide%2Ftopics%2Fui%2Fmulti-window%3Fhl%3Dzh-cn "https://developer.android.google.cn/guide/topics/ui/multi-window?hl=zh-cn")、[多项恢复设计](https://link.juejin.cn/?target=https%3A%2F%2Fsource.android.google.cn%2Fdevices%2Ftech%2Fdisplay%2Fmulti%5Fdisplay%2Fmulti-resume%3Fhl%3Dzh-cn "https://source.android.google.cn/devices/tech/display/multi_display/multi-resume?hl=zh-cn")

### 3.3.1 多项恢复

在 Android 10（API 29）增加多项恢复功能：所有顶层的可聚焦 `Activity` 均处于 `RESUMED` 状态。涉及多窗口的行为变化历史:

1. Android 7.0 支持分屏：左右/上下显示两个窗口
2. Android 8.0 支持画中画，此时处于画中画的`Activity`虽处于前台，但处于 `Paused`状态
3. Android 9.0 (API 28) 及以下：多窗口下，只有获得焦点应用处于`Resumed`状态，其它可见`Activity`扔处于`Paused`状态，如下图左侧
4. Android 10.0 (API 29) ：多窗口模式时，个`Acttivity`全部处于`Resumed`状态  
![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,sqEyO0CM-Axh0jPCuQBQmqDBHBdOLz6m4UxBioclG6Ds/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a0345b23dadc45efb7da2d3badbc57b6~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

为解决Android 9.0及以下，只有获得焦点应用才处于`Resume`状态，其它可见`Activity`处于`Paused`状态问题。可添加下列属性，手动添加开启多项恢复：

```haskell
<meta-data
    android:name="android.allow_multiple_resumed_activities" android:value="true" />

```

### 3.3.2 专属资源访问

多窗口模式下，当`Activity` 获得/失去顶部位置状态时，会执行新增加的回调 [Activity#onTopResumedActivityChanged(isTopResumed)](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Freference%2Fandroid%2Fapp%2FActivity%3Fhl%3Dzh-cn%23onTopResumedActivityChanged "https://developer.android.google.cn/reference/android/app/Activity?hl=zh-cn#onTopResumedActivityChanged")， `isTopResumed` 标识当前 `Activity` 是**否处于多窗口模式下的最顶层**。

当我们使用了独占资源时就要用到这个方法。什么叫独占资源？麦克风、摄像头就是，这类资源同一时间只能给一个 `Activity` 使用。以摄像头使用为例，在Android10上，官方建议使用 [CameraManager.AvailabilityCallback#onCameraAccessPrioritiesChanged()](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Freference%2Fandroid%2Fhardware%2Fcamera2%2FCameraManager.AvailabilityCallback%3Fhl%3Dzh-cn%23onCameraAccessPrioritiesChanged%28%29 "https://developer.android.google.cn/reference/android/hardware/camera2/CameraManager.AvailabilityCallback?hl=zh-cn#onCameraAccessPrioritiesChanged()")监听摄像头是否可用。当收到`Activity#onTopResumedActivityChanged(isTopResumed)`回调时，

* `isTopResumed = false` 时，需要在此时判断是否释放独占资源，而不必在一失去焦点时就释放资源；
* `isTopResumed = true` 时 ，可以申请独占的摄像头资源，原持有摄像头资源的应用将收到 [CameraDevice.StateCallback#onDisconnected()](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Freference%2Fandroid%2Fhardware%2Fcamera2%2FCameraDevice.StateCallback%3Fhl%3Dzh-cn%23onDisconnected%28android.hardware.camera2.CameraDevice%29 "https://developer.android.google.cn/reference/android/hardware/camera2/CameraDevice.StateCallback?hl=zh-cn#onDisconnected(android.hardware.camera2.CameraDevice)") 回调后，对摄像头设备进行的后续调用将抛出 [CameraAccessException](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Freference%2Fandroid%2Fhardware%2Fcamera2%2FCameraAccessException%3Fhl%3Dzh-cn "https://developer.android.google.cn/reference/android/hardware/camera2/CameraAccessException?hl=zh-cn")

### 3.3.3 多窗口数据拖拽

多窗口下，支持跨应用数据拖拽功能，开始执行拖放操作时，来源应用必须设置 [DRAG\_FLAG\_GLOBAL](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Freference%2Fandroid%2Fview%2FView%23DRAG%5FFLAG%5FGLOBAL "https://developer.android.google.cn/reference/android/view/View#DRAG_FLAG_GLOBAL") 标志，以示用户可以将数据拖动到其他应用，更多详情参考Android 官方文档：[拖放](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fguide%2Ftopics%2Fui%2Fdrag-drop "https://developer.android.google.cn/guide/topics/ui/drag-drop")

## 3.4 折叠屏适配更多优化

**灵活布局**

* 使用`wrap_content`、`match_parent`避免硬编码
* 使用 `ConstraintLayout`左根布局，方便屏幕尺寸变化，视图自动移动和拉伸

**备用布局**

* 布局文件使用宽度、屏幕方向限定符（`port` 或 `land`）单独适配
* Fragment界面组件模块化

**图片资源**：.9图、矢量图

更多详细适配参考[官方文档：支持不同的屏幕尺寸](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Ftraining%2Fmultiscreen%2Fscreensizes "https://developer.android.google.cn/training/multiscreen/screensizes")

## 4 厂商适配

折叠屏厂商发布了对应适配文档的主要有：三星、华为、微软等。

1. **三星折叠屏适配**  
主要参考[三星折叠屏适配指导](https://link.juejin.cn/?target=https%3A%2F%2Fsupport-cn.samsung.com%2FApp%2FDeveloperChina%2Fnotice%2Fdetail%3Fnoticeid%3D94 "https://support-cn.samsung.com/App/DeveloperChina/notice/detail?noticeid=94")，基本同[Android官方适配指南](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fguide%2Ftopics%2Fui%2Ffoldables%3Fhl%3Dzh-cn "https://developer.android.google.cn/guide/topics/ui/foldables?hl=zh-cn")相差不大，部分需要独立适配的，只需针对三星屏幕信息进行适配即可。如折叠后纵横比 `21 : 9`，展开纵横比：`4.2 : 3`等。
2. **微软Surface Duo双屏适配**  
在Android 官方适配指南的基础上，可再参考Surface官方：[Surface Duo 开发人员文档 ](https://link.juejin.cn/?target=https%3A%2F%2Fdocs.microsoft.com%2Fzh-cn%2Fdual-screen%2F "https://docs.microsoft.com/zh-cn/dual-screen/")进行完全适配。Surfce不仅提供了其独有的[Surface 双屏布局库](https://link.juejin.cn/?target=https%3A%2F%2Fdocs.microsoft.com%2Fzh-cn%2Fdual-screen%2Fandroid%2Fapi-reference%2Fdualscreen-library%2F "https://docs.microsoft.com/zh-cn/dual-screen/android/api-reference/dualscreen-library/")独有功能，还有部分[适用于 Surface Duo 的 Android 示例应用](https://link.juejin.cn/?target=https%3A%2F%2Fdocs.microsoft.com%2Fzh-cn%2Fdual-screen%2Fandroid%2Fsamples "https://docs.microsoft.com/zh-cn/dual-screen/android/samples")。
3. **华为折叠屏适配官方文档**  
[华为折叠屏应用开发指导](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.huawei.com%2Fconsumer%2Fcn%2Fdoc%2F90101 "https://developer.huawei.com/consumer/cn/doc/90101") 包括提供给UX同学的**设计指引**，以及RD同学的**接入指南**。以下会重点介绍下其独有的华为应用内分屏：平行视界功能

## 4.1 华为折叠屏适配

### 4.1.1 UX 设计新特性

华为折叠屏[UX设计指导](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.huawei.com%2Fconsumer%2Fcn%2Fdoc%2F90101%23h1-2-ux- "https://developer.huawei.com/consumer/cn/doc/90101#h1-2-ux-")，在折叠屏各种使用场景下，给出了设计建议，包括**内容（文字1.2倍、图片、视频等）变化大小范围**、**页面布局设计**、**页面信息架构设计**、**多窗口交互设计**、**各类型应用的典型场景设计实现案例**等。

### 4.1.2 多窗口模式

除了Android 官方支持的多窗口模式（分屏，主要是多应用场景实现），华为还支持单应用方式来实现多窗口多任务。主要实现方案：**悬浮窗**、**平行视界**。

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,s1yHYImdchHuyxWYXS6P88cy6_nvYMtNucILKeQEDzu4/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3628265559ad48748a250e014df1a83a~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

悬浮窗案例：比如 **一步窗口**，在特定场景下，点击控件/按钮/链接/附件等，直接打开一个任务悬浮窗，即为一步窗口。一步窗口主要适用于跨应用的跳转。

**平行视界**

平行视界以 `Activity` 为基本单位实现应用内分屏的系统侧解决方案。应用可以根据自身业务设计分屏显示`Activity`组合，以实现符合应用逻辑的最佳单应用多窗口用户体验。提供以下两种基础分屏模式：

支持2种模式：导航栏、自定义

**通用导航模式（0）**

1. 右分屏永远是最后一个窗口。
2. 任何时候，从左分屏打开的新页面，都会将右分屏的页面替换掉; 从右分屏打开新页面，原右分屏页面向左移，新页面在右分屏打开。
3. 任何时候，从左分屏触发Back，左右分屏中的所有Activity都将退出。

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,sWLYcsH381L9PpKj64diQb6AMuxABKT3Tfr4SZXXhHvY/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/444a174a71d24737bccb9af119f11afe~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

**API 接入**

新型非侵入式集成方式，无SDK；

1. 在**assets**目录下新建配置文件easygo.json
2. 修改AndroidManifest.xml内application中新增**meta-data**  
```groovy  
<meta-data android:name="EasyGoClient" android:value="true" />  
```  
`easygo.json` 配置模板  
![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,skBzGaA6D0Bn7pwKXuANKeT8SAq14uKyI1l6ldv6tkdM/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/eac6c5771a7b4870ba1dad163ee5eb7f~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

## 5 2021 Google I/O：使用 Jetpack WindowManager 进行折叠屏适配

`Jetpack WindowManager` 出现之前，折叠屏适配面临如下一些问题

1. 折叠状态下应用体验较差：如半开状态、桌面模式等折叠姿态下，全屏画面扭曲。
2. 无法正确识别折叠屏类型、可显示范围等。如微软的双屏折叠手机，中间部分无画面区域被铰链遮挡。
3. 缺乏统一适配库支持，开发人员对于不同机型，适配比较繁琐，工作量较大。
4. ...

为了帮助APP开发人员支持新的设备尺寸，并为新旧平台版本上的各种`Window Manager`功能提供通用的API交互。Android官方推出了`Jetpack WindowManager`，面向可折叠设备，将来的版本将扩展为支持更多的显示类型和窗口功能。

本文介绍的Jetpack WindowManager API 大部分基于：`androidx.window:window:1.0.0-alpha09`，[最新Release版本可从官网获取](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fjetpack%2Fandroidx%2Freleases%2Fwindow "https://developer.android.google.cn/jetpack/androidx/releases/window")。

## 5.1 Jetpack WindowManager 的目标

1. 所有类型的可折叠设备提供**统一** **API**,避免各设备单独适配。
2. 可折叠设备的物理属性的信息：**折叠屏类型**、**折叠状态**、**铰链方向**、**窗口显示范围**等信息
3. 最初版本面向**可折叠设备**，将来扩展为支持更多的**显示类型**和**窗口功能**。

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,sJKEECCVNabQw9yG9tny98IekgtHXJmmIPv-GCP-S6o0/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/56bbb95d371a4a4e850e41576b816edd~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

## 5.2 折叠屏需要适配的场景

### 5.2.1 可折叠设备总类

1. **单屏可折叠设备**，配备一个可折叠的屏幕。在 [Multi-Window](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.com%2Fguide%2Ftopics%2Fui%2Fmulti-window%3Fhl%3Dzh%5Fcn "https://developer.android.com/guide/topics/ui/multi-window?hl=zh_cn") 模式下，用户可以在同一屏幕上同时运行多个应用。
2. **双屏可折叠设备**，两个屏幕由合页相连。此类设备也可以折叠，但具有两个不同的逻辑显示区域。

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,s8xh2DDZcuk3I0VtJ1CYYerqWRxjNbcKyS84CT2DxF5E/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1b9cdad19df541b683858bff47f18e44~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

### 5.2.2 折叠姿态

1. 展开态：flat  
   1. 垂直  
   2. 水平
2. 半开态：half-open  
   1. 桌面模式  
   2. 书本模式  
   3. 帐篷模式

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,sHOPJMcOa8VEI3kpOQLArWv9mviBN3avvrG_43j82aMM/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/852c2b791222455a93954b070c0b247b~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

### 5.2.3 折叠信息获取

1. 折叠角度：使用Android 11新增的传感器类型 **TYPE\_HINGE\_ANGLE**获取
2. 折叠姿态：`Jetpack WindowManager`

#### 5.2.3.1 折叠角度获取Demo

利用`TYPE_HINGE_ANGLE`传感器，获取折叠角度demo：

```kotlin
class SensorActivity : AppCompatActivity(), SensorEventListener {
    private var sensorManager: SensorManager?  = null
    private var hingeAngleSensor: Sensor? = null

    public override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sensor)

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        hingeAngleSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_HINGE_ANGLE)
    }

    override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {
        LogUtil.d("onAccuracyChanged $sensor, $accuracy")
    }

    override fun onSensorChanged(event: SensorEvent) {
        val angle = event.values[0]
        LogUtil.d("onSensorChanged $event, $angle")  // 获取角度值
    }

    override fun onResume() {
        super.onResume()
        hingeAngleSensor?.also { light ->
            sensorManager?.registerListener(this, light, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    override fun onPause() {
        super.onPause()
        sensorManager?.unregisterListener(this)
    }
}

```

## 5.3 Jetpack WindowManager API 使用

`Jetpack WindowManager` 是一个以`Kotlin` 优先的现代化库，它支持不同形态的新设备，并提供 "类 AppCompat" 的功能以构建具有响应式 UI 的应用。

`WindowManager` API 包含了以下内容:

* `WindowLayoutInfo`：包含了**窗口的显示特性**，例如该窗口是否可折叠或包含铰链
* `FoldingFeature`： 让您能够监听可折叠设备的**折叠状态**得以判断设备的**姿态**
* `WindowMetrics`： 提供当前窗口或全部**窗口的显示指标**

使用WindowManager适配的主要原理：通**过`WindowManager`获取折叠屏设备信息`FoldingFeature`信息，对于不同的折叠姿态，更新UI显示内容**。

### 5.3.1 FoldingFeature 获取折叠屏物理信息

`FoldingFeature`用来描述屏幕的折叠状态或两个物理显示面板之间的铰链状态。主要的API功能如下：

* `getType()`：  
   * 取值：`TYPE_FOLD`。表示屏幕为**无物理间隙**的柔性屏幕中的折叠。市面上大部分常见的折叠屏，如Samsung Fold、华为 Mate X。  
   * 取值：`TYPE_HINGE`。表示屏幕为带有**铰链**（不可显示区域）的两块屏幕，市面上目前比较少见，典型的指：Surface Duo
* `getState()`：折叠状态，主要有：`STATE_FLAT`（展开）、`STATE_HALF_OPENED`（半开）两种状态。
* `getBounds()`：折叠功能边界的 Rect 实例，指示折叠屏当前可显示的屏幕可见范围。
* `getOrientation()`：折叠屏铰链防线：`ORIENTATION_HORIZONTAL`、`ORIENTATION_VERTICAL`。
* `isSeparating()`：内容区域是否分割为2块。 true：半开或双屏设备；false：计算是否有遮挡

#### 5.3.1.1 设备处于 TableTop 模式

屏幕半开并且铰链处于水平方向

```kotlin
fun isTableTopMode(foldFeature: FoldingFeature) =
    foldFeature.isSeparating &&
            foldFeature.orientation == FoldingFeature.Orientation.HORIZONTAL

```

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,slVXbMI-Kix-TKG_4mS_ZpiF8pjYuORn4pVLVxUdvlZM/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/67800a508bd841c782445b8a28172b86~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

#### 5.3.1.2 设备处于 Book 模式

屏幕半开并且铰链处于垂直方向

```kotlin
fun isBookMode(foldFeature: FoldingFeature) =
    foldFeature.isSeparating &&
            foldFeature.orientation == FoldingFeature.Orientation.VERTICAL

```

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,sgTKPscFDWIZ23g3mOExrPvNtabrmHQQzHWEqt33gKNs/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f0db95d9d06a4cd9967566dbbbd42ba3~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

### 5.3.2 获取折叠变化通知

获取折叠变化通知的2种方式：`WindowManager` 和 `WindowInfoRepo`

#### 5.3.2.1 WindowManager

描述当前窗口的状态；监听窗口变化

* `getCurrentWindowMetrics()`：当前窗口状态。
* `getMaximumWindowMetrics()`：当前系统的最大窗口状态。
* `registerLayoutChangeCallback()` 与 `unregisterLayoutChangeCallback()`: 窗口变化注册、解注册监听

**主要实现步骤**：

1. 实例化`WindowManager`
2. 实现回调接口  
获取到：windowLayoutInfo，foldFeature
3. `onStart`注册回调：传线程池参数、`onStop`解注册

```kotlin
class FoldVerticalPageActivity : AppCompatActivity() {
    private lateinit var binding: ActivityFoldVerticalPageBinding
    private lateinit var windowManager: WindowManager
    private val handler = Handler(Looper.getMainLooper())
    private val mainThreadExecutor = Executor { r: Runnable -> handler.post(r) }
    private val stateContainer = StateContainer()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        windowManager = WindowManager(this)
        binding = ActivityFoldVerticalPageBinding.inflate(layoutInflater)
        val view = binding.root
        setContentView(view)
    }

    override fun onStart() {
        super.onStart()
        windowManager.registerLayoutChangeCallback(mainThreadExecutor, stateContainer)
    }

    override fun onStop() {
        super.onStop()
        windowManager.unregisterLayoutChangeCallback(stateContainer)
    }

    inner class StateContainer : Consumer<WindowLayoutInfo> {
        var lastLayoutInfo: WindowLayoutInfo? = null

        override fun accept(newLayoutInfo: WindowLayoutInfo) {
            for (displayFeature in newLayoutInfo.displayFeatures) {
                LogUtil.d("displayFeature=$displayFeature")
                val foldFeature = displayFeature as? FoldingFeature
                foldFeature ?: continue
                if (foldFeature.isSeparating) {
                    // 折叠屏半开状态：桌面、书本等模式
                    val halfFold = foldPosition(binding.root, foldFeature)
                    ConstraintLayout.getSharedValues().fireNewValue(R.id.fold, halfFold)
                } else {
                    // 折叠屏完全展开
                    ConstraintLayout.getSharedValues().fireNewValue(R.id.fold, 0)
                }
            }
        }
    }
}

fun foldPosition(view: View, foldingFeature: FoldingFeature): Int {
    val splitRect = getFeatureBoundsInWindow(foldingFeature, view)
    splitRect?.let {
        return view.height.minus(splitRect.top)
    }
    return 0
}

```

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.motion.widget.MotionLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/root"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@android:color/black"
    app:layoutDescription="@xml/activity_fold_horizontal_page_scene"
    tools:context=".FoldVerticalPageActivity">

    <ImageView
        android:id="@+id/player_view"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:background="@android:color/holo_red_light"
        app:layout_constraintBottom_toBottomOf="@+id/fold"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintTop_toTopOf="parent" />

    <androidx.constraintlayout.widget.ReactiveGuide
        android:id="@+id/fold"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:orientation="vertical"
        app:layout_constraintGuide_end="10dp"
        app:reactiveGuide_animateChange="true"
        app:reactiveGuide_applyToAllConstraintSets="true"
        app:reactiveGuide_valueId="@id/fold" />

    <!--这部分仅在半折叠时显示；其余时间隐藏-->
    <ImageView
        android:id="@+id/control_view"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:background="@android:color/holo_blue_light"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/fold" />

</androidx.constraintlayout.motion.widget.MotionLayout>

```

#### 5.3.2.2 WindowInfoRepo

`WindowInfoRepo`方式，指的是`WindowManager` 1.0.0-**alpha07**版本：将核心窗口库迁移到了 `Kotlin`，依赖`Kotlin Flow`。

主要原理：使用**协程**和**挂起函数**来公开异步数据，可以理解为对原有API的kotlin二次封装，更加便于使用。

```kotlin
private lateinit var windowInfoRepo: WindowInfoRepo
    private var layoutUpdatesJob: Job? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        windowInfoRepo = windowInfoRepository()
        setContentView(R.layout.activity_fold_horizontal_page)
    }

    override fun onStart() {
        super.onStart()
        layoutUpdatesJob = CoroutineScope(Dispatchers.Main).launch {
            windowInfoRepo.windowLayoutInfo
                .collect { newLayoutInfo ->
                    // New posture information
                    ...
                }
        }
    }

    override fun onStop() {
        super.onStop()
        layoutUpdatesJob?.cancel()
    }


```

## 5.4 Foldables - WindowManager with MotionLayout Demo

[Google I/O 官方演示demo](https://link.juejin.cn/?target=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DjIBNhxyciLQ "https://www.youtube.com/watch?v=jIBNhxyciLQ")通过WindowManager + MotionLayout 用来适配播放器的demo。

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,sCt_723fObOEtMW8nr6u1QxJRmzt9y1enK7t8e1DYlBI/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/75c918c0c61540beaa89e5fa20162b84~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

**适配原理：**

1. `MotionLayout` 作根布局，增加平滑动画效果；添加辅助线`ReactiveGuide` fold guideEnd位于0。约束布局由上倒下分别为：  
   1. **播放画面布局**：`PlayerView`  
   2. **fold铰链位置**：`ReactiveGuide`  
   3. **播放控制按钮布局**：`PlayerControlView`
2. 折叠状态时，`ReactiveGuide`位于屏幕最下边边缘，所以`PlayerControlView`默认隐藏
3. 折叠变化后，`ReactiveGuide`上移到**铰链位置**
4. `PlayerView`播放画面平滑上移；`PlayerControllerView`播放控制按钮平滑出现

主要代码实现，参考官方博客：[Tabletop mode on foldable devices](https://link.juejin.cn/?target=https%3A%2F%2Fmedium.com%2Fandroiddevelopers%2Ftabletop-mode-on-foldable-devices-d091b3c500b1 "https://medium.com/androiddevelopers/tabletop-mode-on-foldable-devices-d091b3c500b1")

```stylus
<androidx.constraintlayout.motion.widget.MotionLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/root"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/black"
    app:layoutDescription="@xml/activity_main_scene"
    tools:context=".MainActivity">

    <com.google.android.exoplayer2.ui.PlayerView
        android:id="@+id/player_view"
        android:layout_width="0dp"
        android:layout_height="0dp"
        app:layout_constraintBottom_toTopOf="@+id/fold"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent"
        app:layout_constraintTop_toTopOf="parent"
        app:use_controller="false" />

    <androidx.constraintlayout.widget.ReactiveGuide
        android:id="@+id/fold"
        app:reactiveGuide_valueId="@id/fold"
        app:reactiveGuide_animateChange="true"
        app:reactiveGuide_applyToAllConstraintSets="true"
        android:orientation="horizontal"
        app:layout_constraintGuide_end="0dp"
        android:layout_height="wrap_content"
        android:layout_width="wrap_content" />

    <com.google.android.exoplayer2.ui.PlayerControlView
        android:id="@+id/control_view"
        android:layout_width="0dp"
        android:layout_height="0dp"
        android:background="@color/black"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toBottomOf="@+id/fold" />

</androidx.constraintlayout.motion.widget.MotionLayout>

```

```reasonml
private fun onLayoutInfoChanged(newLayoutInfo: WindowLayoutInfo) {
  if (newLayoutInfo.displayFeatures.isEmpty()) {
    // The display doesn't have a display feature, we may be on a secondary,
    // non foldable-screen, or on the main foldable screen but in a split-view.
    centerPlayer()
  } else {
    newLayoutInfo.displayFeatures.filterIsInstance(FoldingFeature::class.java)
    .firstOrNull { feature -> isInTabletopMode(feature) }
    ?.let { foldingFeature ->
           val fold = foldPosition(binding.root, foldingFeature)
           foldPlayer(fold)
          } ?: run {
      centerPlayer()
    }
  }
}

private fun centerPlayer() {
	ConstraintLayout.getSharedValues().fireNewValue(R.id.fold, 0)
  binding.playerView.useController = true // use embedded controls
}

private fun foldPlayer(fold: Int) {
  ConstraintLayout.getSharedValues().fireNewValue(R.id.fold, fold)
  binding.playerView.useController = false // use custom controls
}

/**
* Returns the position of the fold relative to the view
*/
fun foldPosition(view: View, foldingFeature: FoldingFeature): Int {
  val splitRect = getFeatureBoundsInWindow(foldingFeature, view)
  splitRect?.let {
    return view.height.minus(splitRect.top)
  }

  return 0
}


```

## 6\. 2021 Google I/O：更新SlidingPaneLayout 1.2支持双窗格

**背景**：

`ConstraintLayout` 能让单窗格根据多种屏幕尺寸，进行自适应调整，但大屏幕设备显示时，可能会从将布局拆分为多个窗格来显示，这个时候就需要`SlidingPaneLayout` 来支持

## 6.1 新特性

自动调整两个窗格的大小，使窗格位于折叠/铰链等任一侧位置。

* 大屏/可折叠设备上：并排显示两个窗格
* 小屏：自动调整显示一个窗格

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,s2-pldqSkXtOp5EWBPgp7Pen7wA8673aI809G0QFlc70/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/022282695e8f4ee5ae309cb83601b67a~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

## 6.2 行为变更

1. 每个窗格都会延伸至屏幕边缘，当打开 SlidingPaneLayout 时，详情窗格会完全覆盖列表窗格。
2. 默认“关闭”，即显示列表窗格。调用openPane()显示详情窗格。

## 6.3 API变更

1. 允许注册多个 PanelSlideListener
2. 设置锁定模式，控制用户能否在列表窗格和详情窗格之间滑动

更多详细参考官方：[创建双窗格布局](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fguide%2Ftopics%2Fui%2Flayout%2Ftwopane "https://developer.android.google.cn/guide/topics/ui/layout/twopane")，以及 [SlidingPaneLayout API](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Freference%2Fandroidx%2Fslidingpanelayout%2Fwidget%2FSlidingPaneLayout "https://developer.android.google.cn/reference/androidx/slidingpanelayout/widget/SlidingPaneLayout")

## 7\. 2021 Google I/O：其它组件更新

## 7.1 NavRail

**垂直导航栏**。功能同于底部导航，用这种导航栏实现方式的优点：大屏用户手握屏幕两边，**更容易被点击**，符合人体工程学的导航体验。

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,su-LWHuKLPBzX05G80a6uaRvdVcDLZcFPOSP635fp9r4/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0f1812b778694f02bf9a78fceccf33e4~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

## 7.2 其它组件更新：最大宽度值

Material 组件增加最大宽度值，避免UI 被**拉伸**到整个屏幕的**边缘**

* Buttons (按钮)
* TextFields (文本框)
* Sheets (表单)

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,sKuhGZI-ZVrBZW74MkwTdJcMINlP48Hk_SRSlav5N_Ho/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/94e635ad4f104a6e92ba73e52fc2f2ae~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

## 8 折叠屏调试

这里指折叠屏折叠变化时时，可通过ADB调试模拟窗口大小变化

* 模拟折叠屏展开效果：`adb shell wm size 2200x2480`
* 模拟折叠屏关闭效果：`adb shell wm size 1136x2480`
* 恢复到原始尺寸：`adb shell wm size reset`

新建折叠屏模拟器可选择

![在这里插入图片描述](https://proxy-prod.omnivore-image-cache.app/0x0,suq_FsjXXBkhrTZQ01DJYhQMT2JiJmiOnSnnFVkhWcaA/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d897e165b9c04a3c89bd4cde91c79a68~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

## 参考

1. Android 官方指南：[为可折叠设备构建应用](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.google.cn%2Fguide%2Ftopics%2Fui%2Ffoldables%3Fhl%3Dzh-cn "https://developer.android.google.cn/guide/topics/ui/foldables?hl=zh-cn")
2. Android 官方指南：[Get started with large screens](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.com%2Fguide%2Ftopics%2Flarge-screens%2Fget-started-with-large-screens "https://developer.android.com/guide/topics/large-screens/get-started-with-large-screens")
3. [三星折叠屏适配指导](https://link.juejin.cn/?target=https%3A%2F%2Fsupport-cn.samsung.com%2FApp%2FDeveloperChina%2Fnotice%2Fdetail%3Fnoticeid%3D94 "https://support-cn.samsung.com/App/DeveloperChina/notice/detail?noticeid=94")
4. [华为折叠屏应用开发指导](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.huawei.com%2Fconsumer%2Fcn%2Fdoc%2F90101 "https://developer.huawei.com/consumer/cn/doc/90101")
5. [Surface Duo 开发人员文档](https://link.juejin.cn/?target=https%3A%2F%2Fdocs.microsoft.com%2Fzh-cn%2Fdual-screen%2F "https://docs.microsoft.com/zh-cn/dual-screen/")

本文收录于以下专栏

![cover](https://proxy-prod.omnivore-image-cache.app/0x0,sIEqae9S-MEHHQmB_rdTbt41CV5WqDxdXB_c54pGCxkM/https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/95414745836549ce9143753e2a30facd~tplv-k3u1fbpfcp-jj:80:60:0:0:q75.avis)

下一篇

 Android 非45度倍数角度渐变引起的崩溃

![avatar](https://proxy-prod.omnivore-image-cache.app/0x0,sY5q9UyKC4jmpqeB1K_K4QAsE6rmrDXAHV0F8PQ9-ZHU/https://p6-passport.byteacctimg.com/img/mosaic-legacy/3791/5035712059~40x40.awebp)

---

