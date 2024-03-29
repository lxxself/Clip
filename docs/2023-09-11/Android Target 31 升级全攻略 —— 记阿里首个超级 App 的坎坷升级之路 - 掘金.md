---
id: 85766c1d-2f97-43f5-8037-4c204dca607f
---

# Android Target 31 升级全攻略 —— 记阿里首个超级 App 的坎坷升级之路 - 掘金
#Omnivore

[Read on Omnivore](https://omnivore.app/me/android-target-31-app-18a834c2313)
[Read Original](https://juejin.cn/post/7114225231845457956)

![](https://proxy-prod.omnivore-image-cache.app/0x0,s2WH-qisiyu7jPJY4iqaaL6Ok5WnC9kbGwn2acbJZW5Y/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7a20824e51d241c1931a9381d9d5be16~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

作者：杨夕凯、张炅轩

## 简述

Android Target 版本作为应用和系统版本间的“协议”与“桥梁”，在厂商预装合作、应用商店曝光、开放能力方面都是一个重要衡量标准，近年来谷歌和手机厂商对于 Target 升级的推动速度和力度明显加大。Target 版本越高，对系统和用户的安全性相应越好，但其对应用的改动、约束和不明确的坑也随之增多，尤其是对使用系统API范围广、业务复杂、稳定性要求高的超级应用挑战很大。

高德地图此次一鼓作气从 Target 28 升级到 最新的 Target31，成为业界首个升级到最新版本的头部应用，满足了应用市场、厂商预装合规的要求，为后续市场先发、预装合作等赢得了时间窗口。第一个“吃螃蟹”，踩了不少坑，因此我们总结了升级过程中遇到的问题、原理、解决方案及操作方式，希望能帮大家在升级 Target 中事半功倍。

## 1.1 释义：何为 Target 版本

Target 版本，用白话意思是「告知系统我已满足指定系统版本的合规要求，并愿意受约束」。具体指:

* 从约束上，和一般的强制约束（例如用户升级到 Android 12 就必须满足某个条件）不同，Target 版本为我们提供了一种“柔和、缓冲适配”的途径，允许用户在升级 Android 12 时，先临时不受新系统约束（Target 为老版本），而是等自己“准备就绪后”在升级 Target 版本以满足约束，更具灵活性；
* 从强度上，Target 版本越高，受到的约束越多，且约束力越强，这里的版本为“系统 API 版本号”，和 Android 版本一一对应，如 28 对应的是 Android 9，29 为 Android 10，以此类推。

## 1.2 挑战：变化快、成本高的原因

为什么近期 Target 升级推动快、成本高呢？从行业发展和技术的角度来看：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sbN7Yl0C1IXsSl40VT03OPRWAGhTk4JBQBRYTi8A4-50/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/42e04316e0354995bcb972ba1ecc4805~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

从**行业发展**看趋势：

* **厂商跟进快：** 近年来对于 Target 升级的要求表现了“趋紧”和“趋严”，通过此手段，可从系统层面约束各 App 满足隐私合规、统一用户体验等要求；其中：

a、针对预装应用，作为 CTS（Compatibility Test Suite，谷歌的兼容性测试套件）集成的必要一环，若不能及时响应 Target 升级诉求，则很有可能导致预装下架，进而对厂商合作、应用带量等造成严重影响；

b、针对市场应用，通过TAF 《移动应用软件高API等级预置与分发自律公约》等公约，从经验看会在 1-2年内将条件扩展到应用商店，即便不涉及预装应用，则仍要未雨绸缪

* **隐私力度强**：无论政府监管部门，还是厂商、Google，其满足“隐私合规”的要求越加频繁，曾经“粗放”的App 权限已成过去，从长远看，此种限制对用户是有显著收益的，但对于应用开发者而言，需要及时响应、明确趋势，充分理解和执行；
* **碎片设备多**：谷歌和各厂商/ROM 对于隐私、API 调整等的理解不同，其不同版本、不同设备的实施效果有较大差异，且“碎片化”愈演愈烈。如“大致位置”、“启动图”等，各厂商会根据自己的需求来做二次开发，导致在谷歌原生的适配方法，到其它 ROM 中则存在问题

从**技术**看问题：

* **变化频繁**：以 Android 12 为例，Release 发布后至少有 5 次文档变动（包括启动图、模糊定位、文件存储等），并下发过 Release Patch 至厂商，厂商再根据自己的需求、节奏来看是否“实施”Patch，导致适配成本成倍增加；加之各 ROM 的碎片化，过程中需要持续调整对焦
* **材料不全**：当时业内无较好的分析文档，主流 App 也未适配到 31，很多需要自己探索，如新增权限判断、外置存储使用、启动图等，官方要么未提及，要么只说大概，需要自己分析源码 + 不断的实践才能明确。
* **适配困难**：每一个权限调整，其涉及 API 众多、用户影响高，且适配量很大，以我们为例，相比过去 Target 21 → 26 的 20+ 系统 API，本次涉及 300+ 系统 API，上千处调用，涵盖多个技术栈，改造成本高、影响范围广，为我们的适配带来了不小挑战

作为高速发展的超级 App，高德需要做到既保持内部“持续的业务增长”，又能消化外部“要求高、变化快、难度大”。经过大家的不懈努力，最终圆满完成了 Target 28 → 31 的升级。

## 1.3 收益

1. 为满足应用市场、厂商预装合规要求，政府、厂商、电信终端产业协会公约 打好提前量，为后续市场先发、预装合作赢得的时间窗口，避免卡脖子；
2. 在专项过程中沉淀了升级、合规相关经验，设计并落地系统隔离层，降低后续改动对业务的影响，提升后续对新系统、华米 OV ROM、鸿蒙等的应对效率；
3. 通过源码分析+自研脚本，成功识别 13 个谷歌未提及的改动，减少了 119 个潜在崩溃、不可用风险。

## 隐私权限

## 2.1 外置存储、分区存储与限制【29,30】

### 背景

为了更好保护用户数据并限制设备冗余文件增加，若应用升级到 Target 29，在默认情况下被赋予了对外部存储设备的分区访问权限（即分区存储），应用只能看到本应用专有的沙箱目录以及特定类型的媒体（通过MediaStore）。

### 现状（SDK=28为目标平台的应用）

当用户授予“存储”权限，允许读写外置非沙盒目录的内容，并在卸载重装后不会被清除；此外，一些用户相册、敏感信息，在授予权限后也可以读取到。

### Target 升级后不同访问方式表现

前提：

* 设置requestLegacyExternalStorage=true 和 PreserveLegacyExternalStorage=true
* APK targetSDK升级到31
* 新装/卸载后重装 APK

目录：

* 共享目录：存储其他应用可访问文件， 包含媒体文件、文档文件以及其他文件，对应设备DCIM、Pictures、Alarms, Music, Notifications,Podcasts, Ringtones、Movies、Download等目录;
* 沙箱内目录：  
   * /sdcard/Android/data/{packagename}  
   * /data/data/{packagename}  
   * /sdcard/Android/media/{packagename}
* 其他目录：系统或其他应用在外置SD卡创建的目录；

坑点&避坑建议（已在小米、ov等主流机型验证）：

* 坑点：在Android 11+、Target 为 30+ 且用户新装/卸载重装时，即便没有存储权限，写入超过sdcard两级子目录（比如：/sdcard/xxx/yyy）系统返回“可读写”仍为 true，不符合预期；直到对文件内容做读写时，系统才抛出写入异常，导致失败。
* 避坑建议：由于单一依靠系统返回结果已不可信，因此对系统返回结果做双重校验。如：Android 11 及以上且“可读写”返回 true 后，写入临时文件，若写入失败则仍放入沙箱。

### 总结&适配建议

* 覆盖安装不会自动开启分区存储，原有存储访问权限不受影响；
* 应用可通过requestLegacyExternalStorage和PreserveLegacyExternalStorage两个属性禁掉分区存储机制来完成数据迁移，但这两个属性只对升级有效，在android 11后的机器新装/重装会强制开启分区存储机制；
* 分区存储开启后无需申请存储权限即可正常访问沙箱内目录；
* 分区存储开启后非沙箱内目录访问会受限，具体表现见上表格；
* 分区存储开启后仍然需要申请存储权限，否则访问共享目录会受限。

## 2.2 蓝牙权限及不同策略【29,30,31】

### 涉及权限的蓝牙API

大致可以分为下面三类：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sxoCVIgOPZq5BXOV9pd0FvK9vTK9IhgOXkY0DKrC-KCE/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/06b2e3f158ed4dad8aebb567f4641ce2~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

### 蓝牙权限在不同版本的要求

* **Target ≤ 28 时：** 具备BLUETOOTH和BLUETOOT\_ADMIN权限就能使用连接类API和广播类API，扫描类API需要具备大致定位权限（ACCESS\_COARSE\_LOCATION）
* **Target 为 29 和 30 时**：连接类API和广播类API权限无变化，扫描类API需要另外具备精确定位权限(ACCESS\_FINE\_LOCATION)。
* **Target ≥ 31 时：** 新增了细分的蓝牙权限来替代BLUETOOTH和BLUETOOTH\_ADIMIN，为应用提供更灵活的权限申请方式。具体包括：  
   * BLUETOOTH\_SCAN：允许扫描和发现设备，扫描类API需要同时具备该权限和精确定位权限(ACCESS\_FINE\_LOCATION)。  
   * BLUETOOTH\_CONNECT：允许连接和访问已配对的设备，连接类API需要具备该权限。  
   * BLUETOOTH\_ADVERTISE：允许向附近的蓝牙设备进行广播，广播类API需要具备该权限。

对于新增的这三个权限的弹窗表现，我们也实际测试了一下，现象如下：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sph1N-A-oaqNkC2F8p_Sde3LmjTFmBPOQkpa7ci7AKQA/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a8ae89389c51455a8b08f98a7b2e4e60~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

不同版本中蓝牙API与权限的对应关系，最终总结起来如下：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sYARMom1BxqmPjnLXXkjYpX_L9VQW0w6ljbljtFrXfiI/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4d7f737e06b64d2c9680073191a9bfbe~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

### 适配方案

* 在不同的Android版本中，蓝牙API的使用方式并未发生变化，所以只需要对权限进行相应的适配，避免因未授权而导致的崩溃即可；
* 如果同时使用了蓝牙的扫描、连接和广播类API，对应的权限都需要进行申请。考虑到蓝牙的这三类操作往往是紧密相连的，比如扫描发现后，就会进行连接，如果一次性申请扫描、连接和广播所需的所有蓝牙权限能更好的满足使用场景，同时也能避免重复弹出权限弹窗，使交互更加简洁。因此我们最终采取了组合申请的方式；
* 组合申请蓝牙权限时，在Vivo IQOO 5上的系统权限弹窗如图：

![](https://proxy-prod.omnivore-image-cache.app/0x0,s7efC3rLacEKQ2LlJIDBs2Z_anSQ7E_bxZnJ707EDdHw/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/28abbb92f0b94645a237d82cfe2af90e~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

以下是Target SDK从28升级到31需要做的适配：

1. **为不同Android版本申明不同的权限**
* 为了继续兼容SDK 29-30，需要保留在Manifest中申明的BLUETOOTH和BLUETOOTH\_ADMIN权限，同时还应声明maxSdkVersion为30，ACCESS\_COARSE\_LOCATION也需要保留，如：

```xml
  <!-- Request legacy Bluetooth permissions on older devices. -->
    <uses-permission android:name="android.permission.BLUETOOTH"
                     android:maxSdkVersion="30" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"
                     android:maxSdkVersion="30" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

```

* 新增BLUETOOTH\_SCAN，BLUETOOTH\_CONNECT 和BLUETOOTH\_ADVERTISE权限的申明。如

```applescript
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />

```

* 新增ACCESS\_FINE\_LOCATION权限申明（如果确定应用不会推导用户位置，可跳过此申明和下面的动态申请。但需在BLUETOOTH\_SCAN权限申明时，添加android:usesPermissionFlags="neverForLocation"申明）

**2、动态申请运行时权限**

* SDK 29-30，需要动态申请获得ACCESS\_FINE\_LOCATION
* SDK ≥ 31，先动态申请获得ACCESS\_COARSE\_LOCATION+ACCESS\_FINE\_LOCATION（模糊定位引入的新要求，详见下文)，然后再组合BLUETOOTH\_SCAN、BLUETOOTH\_CONNECT和BLUETOOTH\_ADVERTISE一起申请获得蓝牙权限。如果在未获得ACCESS\_FINE\_LOCATION的情况下，直接申请蓝牙权限，可能导致请求被忽略的异常结果。

**3、使用API前做权限校验**

使用涉及权限的蓝牙API前，需做权限校验。确定已具备相应权限，再继续调用；否则应停止调用，否则可能导致应用直接崩溃。

* SDK 29-30，判断是否具备ACCESS\_FINE\_LOCATION权限即可
* SDK ≥ 31，因为采用了组合申请方式，我们可以直接判断是否同时具备ACCESS\_FINE\_LOCATION和BLUETOOTH\_SCAN即可

## 2.3 大致位置【31】

（厂商称“模糊定位”，以下做统一）

### 背景

升级到Target 31后，在Android 12系统的定位权限设置页和授权弹窗中，明确区分了精确定位和模糊定位，并允许用户选择仅使用模糊定位，即当开启“模糊定位”时，其“精准定位”权限被关闭。此前，小米/Vivo的部分Android 11机型已经采用了这种方式为用户提供更灵活的定位选择，Android target 31升级算是借鉴了相同的思路。可以理解为，在原先仅小米/Vivo 支持“模糊定位”（关闭精确定位）的基础上，Target 升级后，将其扩展到了 Oppo/华为/三星等其他厂商的所有 Android 12 系统。

### 不同厂商/版本策略

![](https://proxy-prod.omnivore-image-cache.app/0x0,sy8Qb1oxFJLUAtr_PckGZ-heCkY1WeMpUMFFp4rmItc4/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dd88755407fb4e7aabd0ec558f39bb32~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

图 定位权限设置页

![](https://proxy-prod.omnivore-image-cache.app/0x0,sE-QAe2WJijkN5-PHQQkFOEZQGxP5uGp0JnX8xnlJr78/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0a63538f1a894fd68bb79fbca5cd12d9~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

图 定位授权弹窗

以下是Target 31升级前后关于模糊定位的对比情况：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sz5SjT-DnDC1T_In3EAAEsDzU2f2WfwQmdFUt-Tyu3AI/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6d9c2faea014432f99d3019f74506b4c~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

可以看到，如果应用仅使用模糊定位，那么不会受到任何影响。但对于高度依赖精确定位的应用，则需要进行相应的适配，确保获得精确定位权限。

### 适配方案

1. **判断应用是否具备精确定位权限**
* Target ≤ 30且支持模糊定位的机型（小米/Vivo），需使用厂商提供的API进行判断，具体可参见各厂商适配相关文档（官网或内部发布文档）
* Target ≥ 31的机型，可直接使用系统API，即Context.checkSelfPermission()判断是否具备ACCESS\_FINE\_LOCATION即可。

**2、引导用户开启精确定位：** 可以在弹出授权弹窗前，或者去到应用权限设置页面前，向用户展示引导性的弹窗或文案，提示其开启精确定位。

## 2.4 在后台访问位置信息的权限【29,30】

### 背景

为了让用户更好地控制应用对位置信息的访问权限，从Android10开始加强了后台定位权限申请的管控。在介绍变更之前需先了解后台定位的场景，除非符合以下条件之一，否则应用将被视为在后台访问位置信息：

* 属于该应用的 Activity 可见；
* 该应用运行的某个前台设备已声明前台服务类型为 location。

### 升级后的变化

* **Target = 29 时：** 开始引入了 ACCESS\_BACKGROUND\_LOCATION 权限，应用需在AndroidManifest声明ACCESS\_BACKGROUND\_LOCATION 权限，然后动态申请该权限且用户选择“始终允许”才能获取到后台定位能力；

![](https://proxy-prod.omnivore-image-cache.app/0x0,sFJ53AsNQagzyRL77-1kMwOKU8CzNmXVjmslsaceJ4u0/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8ae97c4a26084bf28a6b475fa3c6e993~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

* **Target ≥ 30 时**：应用需在AndroidManifest声明ACCESS\_BACKGROUND\_LOCATION 权限，然后用户在系统设置页面上选择“始终允许”后才能获取到后台定位能力。

![](https://proxy-prod.omnivore-image-cache.app/0x0,scLOOVMj4W84Z8k5nSsa20WlG0RSt4A1dfYLT3LzdlCM/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c02423ec21e84ee6bee0052c43524b49~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

注意：通过requestPermission去动态申请ACCESS\_BACKGROUND\_LOCATION 权限，系统将忽略该请求不会弹窗。如果您同时请求在前台访问位置信息的权限和在后台访问位置信息的权限， 系统会忽略该请求，且不会向您的应用授予其中的任一权限。

### 适配建议

* 由于不同target后台定位权限获取方式不一致，如果需要后台访问位置权限，建议从产品侧引导用户去系统设置添加
* 不要同时申请前台和后台访问位置权限，否则无法显示授权弹窗

## 2.5 精准的闹钟权限【31】

### 背景

为了鼓励应用节省系统资源，Android 12 要求为以 Android 12 为目标平台且设置精确的闹钟的应用配置“闹钟和提醒”特殊应用访问权限。如需获取这种特殊应用访问权限，请在清单中请求 SCHEDULE\_EXACT\_ALARM 权限。精确的闹钟只能用于面向用户的功能，且用户和系统均可撤消“闹钟和提醒”特殊应用访问权限，因此需要时加权限判断，否则会抛出Exception。

### 适配建议

需要精确的闹钟的得申请SCHEDULE\_EXACT\_ALARM权限，且使用时做权限判断。

## 2.6 一些电话 API、蓝牙 API 和 WLAN API 需要精确位置权限【29】

### 背景

如果应用以 Android 10 或更高版本为目标平台， 则它必须具有 ACCESS\_FINE\_LOCATION 权限才能使用 Telephony、WLAN、WLAN 感知和蓝牙（蓝牙上面章节已介绍）API中的一些方法。涉及影响的类主要有：

1）电话：TelephonyManager、TelephonyScanManager、TelephonyScanManager.NetworkScanCallback、PhoneStateListener

2）WLAN：WifiManager、WifiAwareManager、WifiP2pManager、WifiRttManager

### 适配建议

涉及通过无线进行“定位”的API需授予ACCESS\_FINE\_LOCATION权限后方可调用。

## 安全合规

## 3.1 软件包可见性【30】

### 背景

Android 11 更改了应用查询用户已在设备上安装的其他应用以及与之交互的方式。使用 元素，应用可以定义一组自身可访问的其他软件包。通过告知系统应向您的应用显示哪些其他软件包，此元素有助于鼓励最小权限原则。此外，此元素还可帮助 Google Play 等应用商店评估应用为用户提供的隐私权和安全性。

### 现状&影响

通过识别发现主要受影响的系统API包括但不限于：queryIntentActivities、getPackageInfo、getInstalledApplications、getInstalledPackages 等。我们以 getInstalledPackages 和 getInstalledApplications 的API为例：

* 在Target升级前，可直接通过 getInstalledPackages 和 getInstalledApplications 来获取安装的应用
* 当Target升级后，如果未命中白名单的，将无法获取包名。这里提到的白名单主要包括：  
   1. 您自己的应用，即自身应用  
   2. 实现 Android 核心功能的某些系统软件包，如媒体提供程序。  
   3. 通过 startActivityForResult（注意 startActivity 无效）打开自身应用时的应用（仅当次有效）  
   4. 安装了您应用的应用（如当时安装自身应用时的应用市场）  
   5. 通过 bindService/startService/Provider 打开自身应用时的应用（仅当次有效）  
   6. 自己在 Manifest 中声明的包名/签名/IntentFilter/ProviderAuthorities 清单（见“建议”）
* 另外，通过声明 QUERY\_ALL\_PACKAGES 权限可临时忽略上述限制，但 Google Play 已要求在 22年4月，除安全、浏览器、文件等必要应用（无导航应用）外，其余应下线此权限，否则会面临下架风险，因此仅可作为兜底方案。

### 建议

1. 如果有需要查询或者交互的非当前App应用组件，需要在 AndroidManifest 中添加 queries 元素。以下有几种建议，大家可根据自己的实际使用场景来选择，最好遵守最小使用原则。可考虑添加包名、Provider 声明的 android:authorities、通用的 Intent-Filter 等来实现；
2. 【不建议】在 Manifest 中添加 QUERY\_ALL\_PACKAGES 做兜底，避免崩溃，但应考虑 Google Play 及海外市场的限制。

### 补充

关于软件包可见性，除了Google的要求外，国内各大厂商正在要求App添加厂商自定义权限：com.android.permission.GET\_INSTALLED\_APPS，该权限需要用户授权，也就是说未来某App想要获取应用软件列表信息是需要用户授权通过才可以正常获取。

## 3.2 对已配置的 WLAN 网络限制【29】

### 背景

为了保护用户隐私，只有系统应用和设备政策控制器 (DPC) 支持手动配置 WiFi 网络列表（包括增删改/连接 WiFi 等）。如果应用升级 Target 到 29 且应用不是系统应用或 DPC，则有些方法不会返回有用数据，具体表现见下节。

### 升级后的变化

Target升级到29+后获取/操作WIFI列表的行为如下：

* 获取 WiFi 列表；
* 扫描WiFi 列表（startScan），在授予“精确定位”（FINE\_LOCATION）权限后可正常获取，该行为跟升级前一致；
* 若用户仅授予“模糊定位”（COARSE\_LOCATION），则无法获取，返回空；
* 用户已保存的网络（getConfiguredNetworks）则始终无法获取，返回空；
* 添加 WiFi（保存网络）。

需更换新 API（addNetworkSuggestions），当添加新 WiFi 时系统会弹窗等待用户确认（如下图），用户可拒绝添加；其它行为和升级前一致。

![](https://proxy-prod.omnivore-image-cache.app/0x0,saCmvJPnbeTiyptSxSR5pvcb2W3JPC4EiQyVlNV_KT94/https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7cad399cc7b74aa6aba6fd879f16fee5~tplv-k3u1fbpfcp-zoom-in-crop-mark:1512:0:0:0.awebp)

* 移除/修改保存的 WiFi：需更换 为新API removeNetworkSuggestions；
* 主动连接 WiFi：已禁止（enableNetwork），只能交由系统策略处理或者用户去系统设置连接。

### 适配建议

* 获取 WiFi 列表：适配当用户只授予“模糊定位”返回 Null 时的情况；去掉对已保存网络（getConfiguredNetworks）接口的依赖；
* 添加/移除/修改保存的WiFi：更换新 API。考虑到有系统弹窗，如需要的话可引导用户完成。

## 3.3 更安全的组件导出【31】

### 背景

如果您的应用以 Android 12 或更高版本为目标平台，且包含使用 intent 过滤器的 activity、服务或广播接收器，您必须为这些应用组件显式声明 android:exported 属性。

警告：如果 activity、服务或广播接收器使用 intent 过滤器，并且未显式声明 android:exported 的值，您的应用将无法在搭载 Android 12 或更高版本的设备上进行安装。

### 影响

需要check一下activity、服务或广播中包含intent过滤器的场景。

### 思考&建议

官方考虑对于强制声明android:exported 属性，主要是考虑到安全性，自然也建议我们将exported 属性非必需true的都改成false，理想的角度，推荐大家逐一check一下所有的场景。

当然如果大家想更快捷的去解决，推荐在编译期间，解析AndroidManifest，对于没有主动设置exported属性的统一设置，这样也可以一并解决 SDK 相关问题。

这里有个细节需要注意一下，当Activity包含intent 过滤器时，如果没有设置exported属性，系统在运行的时候会将exported解析成true使用，这在系统的源码中也是有体现的；这样我们就需要考虑历史业务场景中：可能会存在没有给exported设置属性，却将exported设为true来使用。

## 3.4 前台服务启动限制【31】

### 背景

以 Android 12 或更高版本为目标平台的应用无法在后台运行时启动前台服务，[少数特殊情况](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.com%2Fguide%2Fcomponents%2Fforeground-services%23background-start-restriction-exemptions "https://developer.android.com/guide/components/foreground-services#background-start-restriction-exemptions")除外。如果应用尝试在后台运行时启动前台服务，则会引发异常。

### 影响

使用到启动前台服务（API如下）的业务场景，需要check是否有从后台启动的情况，如果有看是否满足特殊情况。主要涉及：startForegroundService 和 startForeground 方法。

### 建议：

尽量避免，甚至杜绝（随着系统不断升级，对于从后台启动前台服务越来越严）从后台启动前台服务。建议从静态分析角度查找所有涉及前台调用的 API，梳理和 Check。

## 3.5 前台服务访问摄像头、麦克风需声明【30】

### 背景：

1. 在前台服务中访问摄像头或麦克风，则必须添加前台服务类型 camera 和 microphone；
2. 如果应用在后台运行时启动了某项前台服务， 则该前台服务无法访问麦克风或摄像头，如果想访问位置，需要有后台访问位置信息的权限。

### 影响

前台服务中使用摄像头、麦克风或位置。

### 建议

1. 如果在前台服务中需要使用camera和microphone，需要在AndroidManifest.xml声明对应类型。如下：<service ... android:foregroundServiceType="camera|microphone" />
2. 不建议应用在后台时启动前台服务，因为如果Target升级到31的时候，除非特殊情况，否则无法从后台启动前台服务。

## 3.6 待处理 intent 可变性【31】

### 背景

如果您的应用以 Android 12 为目标平台，则需对 Pending Intent 强制设置“可变性”（即 FLAG\_IMMUTABLE/FLAG\_MUTABLE），这项额外的要求可提高应用的安全性。

### 影响

使用到PendingIntent的业务场景。

### 建议

根据需要为PendingIntent填写 PendingIntent.FLAG\_MUTABLE 或 PendingIntent.FLAG\_IMMUTABLE 标志；此外，最好提供一个适配的聚合类，其他类都直接调用适配类的方法，这样可以减少适配成本。

## 3.7 更新后的非 SDK 限制【29,30,31】

### 背景

从 Android 9（API 级别 28）开始，Android 平台对应用能使用的非 SDK 接口实施了限制。只要应用引用非 SDK 接口或尝试使用反射或 JNI 来获取其句柄，这些限制就适用。这些限制旨在帮助提升用户体验和开发者体验，为用户降低应用发生崩溃的风险，同时为开发者降低紧急发布的风险。

* **区分 SDK 接口和非 SDK 接口：** 一般而言，公共 SDK 接口是在 Android 框架软件包索引中记录的那些接口。非 SDK 接口的处理是 API 抽象出来的实现细节，因此这些接口可能会在不另行通知的情况下随时发生更改。为了避免发生崩溃和意外行为，应用应仅使用 SDK 中经过正式记录的类。这也意味着当您的应用通过反射等机制与类互动时，不应访问 SDK 中未列出的方法或字段；
* **非 SDK API 名单：** 随着每个 Android 版本的发布，会有更多非 SDK 接口受到限制。为最大程度地降低非 SDK 使用限制对开发工作流的影响，将非 SDK 接口分成了几个名单，这些名单界定了非 SDK 接口使用限制的严格程度（取决于应用的目标 API 级别）。

### 影响

[使用google官方提供的工具](https://link.juejin.cn/?target=https%3A%2F%2Fdeveloper.android.com%2Fguide%2Fapp-compatibility%2Frestrictions-non-sdk-interfaces%23list-names "https://developer.android.com/guide/app-compatibility/restrictions-non-sdk-interfaces#list-names")和Android 12 非 SDK 接口及其对应的名单，就可以对需要的APP扫描出结果，根据结果可知道影响范围。

### 建议

理想情况下，我们应该只使用SDK(whitelist)；但是一些App为了获得一些能力，使用了非sdk接口。因此：

* 对于greylist，我们暂且可以使用；
* 对于greylist-max-x，我们需要根据工程中target版本来看是否可以暂且使用，greylist-max-p等价于max-target-p；
* 对于blacklist，则无法使用。另外所有的非sdk接口一定要加try catch保护。

## 写在结束前

以上是我们在 Target 升级中的思考和解法，由于篇幅所限，上述仅介绍了一些隐私安全相关的“关键要点”，具体的技术实现细节，大家若有兴趣，欢迎随时在评论区留言讨论。

Target 升级的关键之处，除了外部（厂商、政府政策）的推动，公司内部对于拥抱隐私合规，对用户负责的积极态度外，还有多方团队的合作，自上而下的重视，以及自内而外的决心，三者缺一不可。Target 升级绝非“一锤子买卖”，它需要长期、持之以恒的耕耘，才能不断结出果实。希望我们的经历，能为大家带来启发，少走弯路，轻装上阵。

**关注【阿里巴巴移动技术】，阿里前沿移动干货&实践给你思考！**

---

