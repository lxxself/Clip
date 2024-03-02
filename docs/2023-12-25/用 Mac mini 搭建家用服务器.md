---
id: adaf9393-c654-48cb-a9be-fcc650d40dae
---

# 用 Mac mini 搭建家用服务器
#Omnivore

[Read on Omnivore](https://omnivore.app/me/mac-mini-18c9f1b3bee)
[Read Original](https://www.jinhuaiyao.com/posts/home-server-with-mac-mini/)

* [一些设置](#一些设置)  
   * [登录 Apple ID](#登录-apple-id)  
   * [关闭 Wifi，连接网线](#关闭-wifi连接网线)  
   * [永不锁屏](#永不锁屏)  
   * [自动登录](#自动登录)  
   * [共享](#共享)
* [备份](#备份)  
   * [iCloud 照片备份](#icloud-照片备份)  
   * [重要文件备份](#重要文件备份)
* [旁路由](#旁路由)
* [定时作业](#定时作业)
* [其他](#其他)  
   * [Reeder](#reeder)  
   * [UPS](#ups)  
   * [](#heading)

因为家里众多设备都是在苹果生态里，也有备份 Onedrive 文件和 iCloud 照片的需求，此外也想使用 Surge 接管家里的科学上网，于是 5 月份购买了 Mac mini 搭建家用服务器，那会儿新工作确定了，有闲情去折腾新东西了。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sp6cF4g5yctvP3KJ0W_4im2fVAufZsslORlDtWEvwg8E/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-1.png)

## 一些设置

## 登录 Apple ID

开启 iCloud 照片和 iCloud Drive。

![](https://proxy-prod.omnivore-image-cache.app/0x0,stIVwKCQE9o-7W-K7H8IJBoOI7fSudQItaEYBiAV0wMs/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-6.png)

## 关闭 Wifi，连接网线

![](https://proxy-prod.omnivore-image-cache.app/0x0,sVckM0zMHt26HPAoauPqTbFeuWMIA8dA1DXAgMqLE-Lw/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-2.png)

## 永不锁屏

关闭锁屏密码。

![](https://proxy-prod.omnivore-image-cache.app/0x0,s2l4MQVpzuF_LbgtsrSJ76N0ChVUtXPsTbQUEUTr0_ps/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-3.jpg)

防止自动睡眠，断电后自动重启。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sOE1_2_EyvvzS_kA-GlH--T3elWnY6U_ttqrDn6SkANU/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-4.jpg)

## 自动登录

![](https://proxy-prod.omnivore-image-cache.app/0x0,sV2bMuAYyASFz7o3bHR1swR51PLz4PxhHPObBPIJIZI8/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-5.jpg)

![](https://proxy-prod.omnivore-image-cache.app/0x0,sOPq6DrFy6IfTTm2y8VN1lAWeITQvlAgCznUqGO9OhYw/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-7.jpg)

## 共享

![](https://proxy-prod.omnivore-image-cache.app/0x0,seiP5bNHOE8tjW415UNItvsoW5Fnqd2gjmH0-kD3-pAM/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-8.jpg)

文件共享

其他设备可以通过网络访问共享文件夹。

![](https://proxy-prod.omnivore-image-cache.app/0x0,s_fyFFlydc7FQiSwxxV7QtH_EFmJ0otnrAwfZdO-6cao/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-9.jpg)

内容缓存

“内容缓存可加快通过互联网分发的 Apple 软件的下载速度。内容缓存可将软件的本地副本储存在 Mac 上，因此所连接的客户端能够加快下载速度”。参考[官方文章](https://support.apple.com/zh-cn/HT204675)。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sQ2duh1eWtXKxsh_5sVp_Luw4KRUo2y7h_WzwDmW7Zgo/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-10.jpg)

远程管理和远程登录

在其他的 Mac 上访问 Mac mini 以及使用远程桌面。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sbbQ4YcuxHN0GWu_1pWxJlLC1lmYB1pR0Zkf6T7wxkfE/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-11.png)

![](https://proxy-prod.omnivore-image-cache.app/0x0,sBc2ueTC7sPk4SzbOxyT1bPSNtqu6KuyQ9WIeN6kS-UY/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-12.png)

## 备份

## iCloud 照片备份

虽说手机里的照片都存在云上，但是没有一份本地的备份总是不放心。研究了一番，最后使用以下方案。

Mac mini 外接 1T 的 SSD 移动硬盘，将照片库的默认存储位置改成外接硬盘，并且设置下载并保留原片，再配置两份 Time Machine 每个小时去备份这个 1T 外接硬盘。

参考[转移照片图库以节省 Mac 上的空间](https://support.apple.com/zh-cn/HT201517)，[在“照片”中指定“系统照片图库”](https://support.apple.com/zh-cn/HT204414)。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sFCJK-k-uhB-A165LbcRfQ_xe_A9yhNdMHVapT294S4k/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-13.jpg)

![](https://proxy-prod.omnivore-image-cache.app/0x0,sCbn9mamvNrMxnbdlo3Gls6MZciSaBRLPseogL8nK0FQ/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-14.jpg)

![](https://proxy-prod.omnivore-image-cache.app/0x0,sR9Pv_F8CaqeiYnmXxUZIGs_AzUiCkqVRrcRN7C1SMfA/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-15.jpg)

![](https://proxy-prod.omnivore-image-cache.app/0x0,sB-1L96xga712SgBxITbVeVAf1M60PWyzmfSzUOB3Fsk/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-16.jpg)

## 重要文件备份

Onedrive/iCloud Drive 挑选重要资料文件夹，将其设置成总是下载到本地。DEVONthink 下载数据库到本地，这三者再通过 Time Machine 进行定期备份到两个外接硬盘。这样重要数据多一份保障，此外本地文件访问也能快些。

## 旁路由

在 Mac mini 上安装 Surge，需要科学上网的设备，就选择使用 Surge 当作网关。此外也可以查看设备的网络访问情况。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sig6bdIrB_0X8MRT93phWubX4CnfqNswZgHnYa27lN8Y/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-18.jpg)

![](https://proxy-prod.omnivore-image-cache.app/0x0,s4N_y2jFZeSRYqUQBDZ5huieDcsGf4Z119qQqN--NNeM/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-19.jpg)

## 定时作业

设置 cronjob 定时运行一些脚本。

```awk
# on this day
01 06 * * * /bin/bash  /Users/jinhuaiyao/Library/CloudStorage/OneDrive-Personal/Config/Mac_Script/on_this_day.sh > /Users/jinhuaiyao/Log/on_this_day.log 2>&1

```

这个之前[写过](https://www.jinhuaiyao.com/posts/about-logseq/#%E9%82%A3%E5%B9%B4%E4%BB%8A%E6%97%A5)，本来运行在 MacBook 上，现在移到 Mac mini 了。

\-

```awk
# sync logseq from icloud to onedrive
*/5 * * * * /usr/bin/rsync -a "/Users/jinhuaiyao/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents/" "/Users/jinhuaiyao/Library/CloudStorage/OneDrive-Personal/Logseq" > /Users/jinhuaiyao/Log/Logseq.bak.log 2>&1

```

每 5 分钟把 Logseq 文件从 iCloud Drive 里从同步到 Onedrive。

\-

```awk
# get home IP
1 * * * * /bin/bash /Users/jinhuaiyao/Library/CloudStorage/OneDrive-Personal/Config/Mac_Script/get_home_ip.sh >/Users/jinhuaiyao/Log/get_home_ip.txt 2>&1

```

运行 `curl cip.cc` 去查看当前 IP，和上一次查询结果对比，如果不一样就输出到 iCloud Drive 里的一个文件。之前开了外网连接的时候用的，现在基本没有这个需求了，不过可以用来记录 IP 的变化。

\-

```crystal
# check if any unknown screen sharing session
*/10 * * * * /bin/bash /Users/jinhuaiyao/Library/CloudStorage/OneDrive-Personal/Config/Mac_Script/ck_screen_sharing_session.sh >/Users/jinhuaiyao/Log/ck_screen_sharing_session.txt 2>&1

```

运行 `netstat` 查看 screen 连接的情况，如果有未知新连接，发邮件。之前开了外网连接的时候用的，已经不需要了。

## 其他

## Reeder

在 Mac mini 上安装 Reeder，配置 30 min 查询 feeds 一次，再通过 iCloud 同步结果，其他设备上就不用重复查询了。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sdGDRJ-L5bdVvBkkoUPG0JANT14Ih8SGuhC2Vv1QFXn0/https://huaiyao-image-hosting.oss-cn-shanghai.aliyuncs.com/images/home-server-with-mac-mini-20.jpg)

## UPS

上周买了 UPS（不间断电源），把光猫、路由器、NAS 和 Mac mini 的电源全都接到 UPS 上，以后家里短暂断电也不会有影响了。

---

