---
id: 5b8bf834-fe10-4a0b-9826-6ae48763175b
---

# 一日一技 | Mac 版微信聊天记录如何自动备份至外接硬盘 - 少数派
#Omnivore

[Read on Omnivore](https://omnivore.app/me/mac-18d625634fc)
[Read Original](https://sspai.com/post/86175)

![](https://proxy-prod.omnivore-image-cache.app/0x0,sSNuZLxfp8o7RI3lDkqsOqoo2JVByWR4hKLiM8IJLEQQ/https://cdn.sspai.com//2020/07/15/03489f13d747077eafb9f844d842ed53.png)

一日一技 | Mac 版微信聊天记录如何自动备份至外接硬盘

**Matrix 首页推荐** 

[Matrix](https://sspai.com/matrix) 是少数派的写作社区，我们主张分享真实的产品体验，有实用价值的经验与思考。我们会不定期挑选 Matrix 最优质的文章，展示来自用户的最真实的体验和观点。   
文章代表作者个人观点，少数派仅对标题和排版略作修改。

---

## 问题描述

我平时使用的电脑是 MacBook Pro M1 版,硬盘存储空间只有 256G，有次系统提示我存储空间告急，在整理文件的过程中，我发现微信在电脑文件中的占比位居榜首，达到 40G 至 50G，那么，如何将微信备份文件迁移到外接硬盘呢？接下来，我就和大家分享下我将微信聊天记录自动备份到外接硬盘的全过程。

![](https://proxy-prod.omnivore-image-cache.app/0x0,s7d0r9zQldWhfhYF-OcCKOS6nz_waKSugTkyJSo0qEN8/https://cdn.sspai.com/2024/01/29/ff92a96012fa03c173ab7105e79dc168.png)

清理后的微信文件依然很大

## 解决方案

如何将微信聊天记录「自动备份至外接硬盘」？其实这里要用到的就是「软链接」。

「[软链接](https://sspai.com/link?target=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FSymbolic%5Flink)」以路径形式存在，也叫符号链接（Symbolic link），类似于 Windows 系统中的「快捷方式」，最早在 Linux 和 Unix 系统中用于创建文件或目录的一种形式。在 macOS 系统里叫做「替身」，链接不同文件系统的文件。

### 操作步骤

所以解决问题的最佳方案，就是把微信备份文件通过软连接放到外接硬盘，这样在 Mac 端微信执行「备份聊天记录至电脑」操作时，通过创建「软链接」的方式，可以将聊天记录直接备份到外接硬盘；需要还原备份时，直接插上硬盘即可显示并恢复相关聊天记录。达到节省 Mac 本地磁盘存储空间的目的。

#### 找到微信聊天记录备份文件默认路径

`/Library/Containers/com.tencent.xinWeChat/Data/Library/Application\ Support/com.tencent.xinWeChat/2.0b4.0.9`

在 Mac 电脑系统内，微信的备份文件会存放在` 2.0b4.0.9` 的 `Backup` 文件夹内，并且备份目录的路径不会改变。每一个微信账号的聊天记录备份对应此目录下的一个文件夹，名称通常为**一长串字母和数字**的组合。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sM6pIJ6jfN-mXXoZJODoQ8JIyDsukYcjjV_XWF3Xmxmo/https://cdn.sspai.com/2024/01/30/4271b006be9efbfeea5120515e095f04.png)

微信备份文件默认路径

如果你的 Mac 版微信没有执行过备份操作，很可能没有 `Backup` 这个文件夹，或者 `Backup` 下面没有子文件夹，为了保证文件权限一致，需要先执行一次备份，生成文件夹目录（无需全部备份，只备份一个人的聊天记录即可），我挑了一个文件最小的聊天记录进行了备份。

需要注意的是，备份操作实际上是将手机微信里的聊天记录备份到电脑里，所以需要将手机和电脑连接至同一网络后，在手机端选择需要备份的聊天记录。在稳定的网络下进行备份，并且过程中不能黑屏，否则会导致备份中断。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sTBosZEYAAMIDhIeriAfMyTmOlvWuBq1auLY_MwdIRWs/https://cdn.sspai.com/2024/01/29/8551142341bc3e548f3dfea317044396.png) 

![](https://proxy-prod.omnivore-image-cache.app/0x0,sHrla5L0OhzsBiaFdhFEuyI2n3GTwBiF0gWtIPS6grGc/https://cdn.sspai.com/2024/01/29/34879072280b1a489314863122397d6e.jpg) 

#### 复制 Backup 文件夹至移动硬盘

备份完成之后，将`Backup`文件夹复制到移动硬盘中的某个位置，例如：`/Volumes/硬盘名/backup/wechat` （注意此处路径中不要有中文，否则微信可能无法读取）

复制完成后，就可以把微信默认备份路径下的 `Backup` 文件夹删除，如果不放心，可以删除前备份一下。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sYSofhwKNt9p6ewhTdkDjFrOMC0bF3lv33-h8FkzbJNg/https://cdn.sspai.com/2024/01/30/7bf6a88f0298a9f49831e2b0bc82a89f.png)

 复制 Backup 文件夹到硬盘

#### 创建软连接

打开终端，执行如下命令：

`` ln -s /Volumes/硬盘名/backup/wechat/Backup `/Library/Containers/com.tencent.xinWeChat/Data/Library/Application\ Support/com.tencent.xinWeChat/2.0b4.0.9/Backup ``

此处我有三点要和大家分享：

1. 需要将命令中的「硬盘名」改成你自己的外接硬盘的盘符名称。
2. 如果硬盘的名称中有空格，写法为反斜杠+空格，例如：`/Volumes/Extreme Pro/backup/`
3. 经过我的实测，我发现只能使用移动硬盘创建软连接，无法用 NAS 做为外部存储。原因是 NAS 为网络挂载，以协议方式传输数据，而非通过 USB 连接外部硬盘。软链接创建后，微信目录下的 `Backup` 就会指向移动硬盘下的 `Backup` 文件夹。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sHNzCjMx98uVCTLqrPhEnVSIB0BLrLkrGjfMPsCqJKls/https://cdn.sspai.com/2024/01/29/e2705cb42992dcc487546e4b2b8232c8.png)

创建软连接（图标左下角带有箭头）

#### 重签名操作

在第一步的时候，我们已经通过一个聊天记录，进行了一次备份操作，在微信「管理备份文件」中，会显示备份文件的名称、时间等信息，但创建软连接后，之前的备份文件却不见了。

原因是 Mac 下的应用是以沙盒模式运行，无法直接读取不在该应用程序以外的文件夹，虽然通过创建软连接的方式将备份文件指向外接硬盘，但实际还是无法读取。解决此问题的方法是将微信重签名，具体操作步骤：退出微信，复制下方代码到终端，回车后盲输密码，再次回车（也可直接输入前段命令后，直接拖动程序到终端）。

`sudo codesign --sign - --force --deep /Applications/WeChat.app`

![](https://proxy-prod.omnivore-image-cache.app/0x0,sWKl7G_8MnmjqiTIcCoz4dqvS58xtvgV0ksrVSKtZunU/https://cdn.sspai.com/2024/01/29/ebbf91772fb8a887fc4f5dbb8f99868e.gif)

微信重签名

重新签名后，当点击微信左下角的设置按钮后，会有「是否允许访问外接硬盘」的弹窗提示，此时需要点击「好」，让微信获得访问权限。

至此，微信便可逃逸沙盒，正常识别到备份文件。再次打开微信，进入到「管理备份文件」界面，我们可以看到之前的备份文件信息。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sR6SDMCjHt-ZriL3M4r-wnH4VSxZz8W3-8sYEp76FGMQ/https://cdn.sspai.com/2024/01/29/7a554f38b5314eeb36fc2a1d71ae001b.png)

备份信息

## 写在最后

以上就是我将 Mac 版微信聊天记录备份到外接硬盘的全过程，以后当我需要备份或恢复聊天记录时，接上硬盘便可。如果你也有类似的需求，不妨试试。

\> 下载少数派 [客户端](https://sspai.com/page/client)、关注 [少数派小红书](https://sspai.com/link?target=https%3A%2F%2Fwww.xiaohongshu.com%2Fuser%2Fprofile%2F63f5d65d000000001001d8d4)，感受精彩数字生活 🍃

\> 实用、好用的 [正版软件](https://sspai.com/mall)，少数派为你呈现🚀

---

