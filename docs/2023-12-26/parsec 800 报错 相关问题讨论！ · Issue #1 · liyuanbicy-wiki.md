---
id: c721367a-11f4-4705-b89c-f42f03d40c7e
---

# parsec 800 报错 相关问题讨论！ · Issue #1 · liyuanbicy/wiki
#Omnivore

[Read on Omnivore](https://omnivore.app/me/parsec-800-issue-1-liyuanbicy-wiki-18ca69491cd)
[Read Original](https://github.com/liyuanbicy/wiki/issues/1)

800报错

无法连接官方服务器 一般为无法直接访问网页和80/443端口

具体原因不知、大部分为移动或者部分电信联通

## **一.错误代码 800**

## **1\. 找一个可以直接打开的代理**

也就是科学上网工具

（不需要流量很多网速很快、只能可以用就行，串流是不走代理的流量的）

我们只是需要他来登录、发现主机而已；串流依旧走的是P2P直连或者内网穿透。

这里下载 <https://github.com/liyuanbicy/wiki>

（免费的凑合能用，但不好用、时不时可能还会报错800.建议花钱找个靠谱的）

**便宜代理的一个传送门：**

<https://9.234456.xyz/abc.html>  
（群友发的，我没用过不做评价和售后）

## **2.务必测试web端（这一步没有操作的、问我也没用）**

测试可以通过代理上

[https://web.parsec.app](https://web.parsec.app/)（主要是这个）

[https://youtube.com](https://youtube.com/)

可以正常打开登录

## **3.parsec客户端配置走代理解决800报错**

说明：

由于parsec的特殊原因、他不能直接引用电脑上运行的代理软件。

需要我们手动写参数到该软件的配置文件中去。

### 方法1：一条参数搞定

只适用于代理服务器就是本机，将 Windows 代理与 Parsec 一起使用：  
说明：一些公司喜欢在计算机和网络之间放置一个代理服务器。这对 Parsec 来说不是问题。您可以通过Parsec 的高级配置文件告诉 Parsec 尊重您的 Windows 代理设置。只需将此行添加到高级配置文件中：  
app\_proxy=1  
（添加后务必重启parsec客户端）

下面是步骤：

**已登录过：**

访问您的高级设置（齿轮点进去拖到最底下选择最长的蓝色字母）

您可以在 Parsec 的设置中访问配置文件，滚动到底部并单击“直接编辑配置文件”。这些在除 Android 之外的所有平台上都可用。

或者，您可以在系统文件中找到 config.txt：

**未登录：**

Windows每个用户安装：%appdata%\\Parsec\\config.txt

共享安装：%programdata%\\Parsec\\config.txt

macOS / Linux / 树莓派：\~/.parsec/config.txt

[![](https://proxy-prod.omnivore-image-cache.app/0x0,sJKAa1a5Lj2U-K_vryTisrp7Gv7UOrfzIzdYo34CuTDI/https://camo.githubusercontent.com/ea1d318c81ab0de29140077aadbac1a1565d5c47f1ddf7bb4e076c96ae9e9360/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f65343932646135646261393234366133616232626265326637396330306236367e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)](https://camo.githubusercontent.com/ea1d318c81ab0de29140077aadbac1a1565d5c47f1ddf7bb4e076c96ae9e9360/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f65343932646135646261393234366133616232626265326637396330306236367e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)

（如果用户名是中文的朋友会在这里遇到报错、显示隐藏文件按照路径去找）

以我为例：C:\\Users\\admin\\AppData\\Roaming\\Parsec 到这个文件夹再去找config.txt

————————————————————————————————————  
加上这一条就可以了

app\_proxy = true

[![](https://proxy-prod.omnivore-image-cache.app/0x0,sJjA-uKtieATy0pNusmRg30uCc76Izj-SdUTzxAuQioo/https://camo.githubusercontent.com/0075b1c756376c7fe7498ea4e4d40cc3dcf90d24c64f8a522caac71e5a78bf57/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f66613230616138616139623134393138383839663834363137323131326565317e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)](https://camo.githubusercontent.com/0075b1c756376c7fe7498ea4e4d40cc3dcf90d24c64f8a522caac71e5a78bf57/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f66613230616138616139623134393138383839663834363137323131326565317e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)

以上操作做完以后、点击parsec右下角图标右键重启

[![](https://proxy-prod.omnivore-image-cache.app/0x0,sCHTbU-bMP0sW1V4zBYn7yCJjXVxHobeUUCAEf5LZCWs/https://camo.githubusercontent.com/7806e0ac0a5561ee3c8fe7a152314aa8afda62b10ffc8723dc247f3304e90118/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f35323331306465613831633034653135383261386537306334643164623762627e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)](https://camo.githubusercontent.com/7806e0ac0a5561ee3c8fe7a152314aa8afda62b10ffc8723dc247f3304e90118/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f35323331306465613831633034653135383261386537306334643164623762627e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)

等待奇迹出现：

[![](https://proxy-prod.omnivore-image-cache.app/0x0,sL9EY2gWRI5M9jWxK9BMpH1qOdmIzYRm8Caq0B2qyTNo/https://camo.githubusercontent.com/5fb431c91941a740a98dab1ec73aa5898eab67956850c6c87fe1d01336f10007/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f36633532346235323436333934326632396166383266323939653766373337307e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)](https://camo.githubusercontent.com/5fb431c91941a740a98dab1ec73aa5898eab67956850c6c87fe1d01336f10007/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f36633532346235323436333934326632396166383266323939653766373337307e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)

---

## **二.错误代码6023（这个视频很多就不细说了）**

直说就是：你的网络不能被直接访问、需要用VPN或者内网穿透的方式来实现

多半为没有公网IP的情况下遇到。

组网之后务必ping一下对端ip地址看一下延迟

走转发 还是延迟高 100ms + 体验不好

如果走P2P 延迟会很低 10-40ms 体验好

（无论如何都延迟高、建议放弃）

## **1.通过蒲公英来搭建虚拟局域网实现连接**

<https://pgy.oray.com/download/personal/#visitor>

<https://service.oray.com/question/4970.html>

按照官方指引搞定了就去连接试一下

还不行就换别的

## **2.通过Tailscale 在组网**

<https://sspai.com/post/66822>

Tailscale属于一种虚拟组网工具，基于WireGuard。

他能帮助我们把安装了Tailscale服务的机器，都放到同一个局域网。也就是我在家里的NAS和PC，还有父母家的PC，甚至云服务器都能放到同一个局域网。

## **3.通过Zerotier 来组网**

（不太推荐、虽然能用但是丢包严重抖动大，挣扎一下的试试）

<https://my.zerotier.com/network>

使用方法很多自己搜一下视频

## **4.如果双端都有ipv6，打开就可以、**

可通过该网址学习<https://ipw.cn/ipv6/> 或测试

## **三.其他问题：**

## **提问1：代理需要一直挂着？**

**不影响其他软件的时候建议一直挂着就可以，串流不会走代理的数据。**

代理的作用只是帮助你登录到服务器、告知另一端你在线罢了、

串流成功后：可以关闭代理软件 一般不影响串流。但仅限每次连接。

原则上：代理影响的是登录状态，不影响串流服务。关了就会报错800

## **提问2：有免费的代理吗？**

**个人认为免费基本是不靠谱的、建议找包月付费的比较便宜的那种**

我自己用的是比较贵的因为有其他用户就不推荐了

群公告放了两个链接，大家自己去找、或者问问其他群友

## **提问3：用了代理还是老出现800 卡顿**

如何测试自己的代理质量<https://fast.com/#> 看下延迟和速率吧

个人认为延迟100以内、速率有个10M左右差不多，主要看延迟。

[![](https://proxy-prod.omnivore-image-cache.app/0x0,sOpBm43oDXs7HjpacPnRjQa0k1Ld7DEWhZ90iKnU6tqs/https://camo.githubusercontent.com/cee806bfcf2b3d3dff7d0f41148008fe38e30507e5ac8ccebfae0d4ee7a0311e/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f62643838653631316430353534356638386663623335623866396265376531307e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)](https://camo.githubusercontent.com/cee806bfcf2b3d3dff7d0f41148008fe38e30507e5ac8ccebfae0d4ee7a0311e/68747470733a2f2f70332d6a75656a696e2e62797465696d672e636f6d2f746f732d636e2d692d6b3375316662706663702f62643838653631316430353534356638386663623335623866396265376531307e74706c762d6b3375316662706663702d7a6f6f6d2d312e696d616765)

## **提问4：为什么我照着视频设置完了还是不行**

1. 只是下载了代理客户端没有可出国的线路，所以白搭
1. 没有先测试网页端和海外网站，这个东西不是写几个参数那么简单。
1. 同时开了两个代理软件，代理A可用代理B不可用，正好配置参数写的代理B。

---

