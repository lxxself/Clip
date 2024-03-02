---
id: 9fc86136-6d5c-11ee-a0d8-1333ebf395fc
---

# 如何用 Make 自动化将即刻动态同步到 Notion - 少数派
#Omnivore

[Read on Omnivore](https://omnivore.app/me/make-notion-18b4093c459)
[Read Original](https://sspai.com/post/83490)

![](https://proxy-prod.omnivore-image-cache.app/0x0,sSNuZLxfp8o7RI3lDkqsOqoo2JVByWR4hKLiM8IJLEQQ/https://cdn.sspai.com//2020/07/15/03489f13d747077eafb9f844d842ed53.png)

如何用 Make 自动化将即刻动态同步到 Notion

将主要精力投入到创作近一年后，我逐步养成了公开分享自己的想法、新学到的知识的习惯。

但有件事一直是我所头疼的，那就是回顾自己一段时间内发过的内容。

作为创作者，我应该算是偏好数据分析、从实践中学习的一类，受推特博主的启发，我学会了定期回顾自己最近创作的内容，看看有哪些表现好的或差的，以便从中学习经验、调整后续的创作。

因为偏好文字创作，我尝试过不少支持图文的平台，在这些选择中，即刻算是我为数不多愿意长期活跃的平台。我发现这里总能让我收获一些高质量的互动反馈，很接近我所追求的创作环境。

只是每当我做定期回顾，想看看自己最近在即刻发过的内容，这事就变得不那么美妙了。我需要有一个地方，除了基础的关键词搜索，还能便捷的查看自己一段时间内发过的内容、支持通过互动数据排序查看。

而即刻作为社交媒体平台，并没有支持得这么细，要想整就得自己动手。

断断续续摸索一个月，我终于实现了一套还算满意的方案，**能定期将我在即刻创作的内容同步到我的 Notion，云端自动运行**，启动后就可以持续收录。

效果如下，左侧是云端运行的自动化，右侧是我在 Notion 专用于归档即刻动态的数据库：

跑通后，我去即刻分享了自己的成果，也意外发现，这套自动化能帮助的似乎不止我一个人。

我用一晚上写了这篇文章、专门做了自动化模板配套分享，下面会手把手教你，如何解锁同款的自动化，让你也能把自己的即刻动态同步到 Notion 里（考虑到本文发布后教程改动的时效性，如果你阅读本文时距离发布已经经过了比较久的时间，建议以 [Notion 分享的这版](https://sspai.com/link?target=https%3A%2F%2Fmrkwtkr.notion.site%2FMake-Notion-e40bb5838a0a449baaf65ded65e28fa3%3Fpvs%3D4) 为准）

因为用到的是低代码平台，**你无需拥有编程知识，只要你不是日更狂魔，云端运行这套自动化也并不需要付费**，免费档的 1000 次操作上限也足够用了（以我的内容发布频率为例，每天运行一次大约会产生 13-26 次操作）。

前置条件

* 一个 Notion 账号 [https://www.notion.so/](https://sspai.com/link?target=https%3A%2F%2Fwww.notion.so%2F)
* 一个 Make 账号 [https://www.make.com/en](https://sspai.com/link?target=https%3A%2F%2Fwww.make.com%2Fen)

接下来，我们将通过这 3 个步骤完成自动化的搭建：

1. 准备 Notion 数据库
2. 获取并配置自动化
3. 配置查询与新建页面的模块

## 1\. 准备 Notion 数据库

为了保证自动化能正常运行，需要有一个配套的 Notion 数据库，包含指定名称和数据类型的属性。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sUaUA5x2A-n-0MtAyCodku_VhB_ua7OxE_5AAmKvp870/https://cdn.sspai.com/2023/10/11/aad9088c509af9ec99581387cd762c6c.png)

这里我已经准备好了一个，你可以直接复制到自己的 Notion 工作区里：

[前往获取 Notion 数据库模板](https://sspai.com/link?target=https%3A%2F%2Fmrkwtkr.notion.site%2F7a0f625c7c264692955071b872d7cf1e%3Fv%3D7284d04c64494edf80bbc32f0ee5c40a%26pvs%3D4)

点击右上角的 **Duplicate**，然后选择自己的工作区，等待片刻即可：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sH7ytc7Lr9tqoKBszHQuqK6fyFK1oZNIpXzRbmOoTHlA/https://cdn.sspai.com/2023/10/11/3e219002a7e8e79ccae8eb22279f86eb.png)

复制好数据库后还要给 Make 授权，因为自动化是通过 Make 运行的，Make 必须要有授权才能读写我们的数据库，继而将收集到的动态数据存入其中。

在数据库的页面中，点击右上角的三点按钮打开更多选项：

![](https://proxy-prod.omnivore-image-cache.app/0x0,s3aDGI2g3ZEBlOpUKXZTPmWzZ4n2lEodWB8hYsfzTAMU/https://cdn.sspai.com/2023/10/11/f1c9f5f55986bd4dc553a9122eb0cdae.png)

往下滑动找到 **Connections > Add connections**，这里是专用于授权第三方应用的入口：

![](https://proxy-prod.omnivore-image-cache.app/0x0,szh-LmftPPd07nvIFwfmQUzvRlPUndZRX6y5VNLCDYCk/https://cdn.sspai.com/2023/10/11/6b8364696f2f0c5150d3e63f9d73742f.png)

输入 **Make** 搜索，选中后点 Confirm 授权

![](https://proxy-prod.omnivore-image-cache.app/0x0,sb24uyoXlNijHvV7e5AW4GcU34-2ylP7oFbWObOOZGcc/https://cdn.sspai.com/2023/10/11/668f6f56663d63ca013a7ef0d104416c.png)

![](https://proxy-prod.omnivore-image-cache.app/0x0,s3R_4fTcmEkjGaN5fUhhuqJCb5Xb4md0fPX3zIoNQamA/https://cdn.sspai.com/2023/10/11/89ad7828db0ed6bfbb673cef3b014448.png)

## 2\. 获取并配置自动化

沿用别人做好的自动化，通常并不是想象得那么轻松，尤其是当对方用着你不熟悉的工具或技术时，环境一变就可能问题百出，而成堆的变量、参数也会让人眼花缭乱。

好在 Make 在分享这块支持得还行，对于这次的自动化，我已经设定好了哪些是需要你手动配置的，理论上你并不需要理解编程上复杂的概念，就能跟着引导、一步步完成基础的配置。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sCxazcL1XnkF9DoCnGT5fuORAniSrh_QNi0JKtNSztvA/https://cdn.sspai.com/2023/10/11/d7eb6a46f784043def2f6f9a95f5a4d8.png)

打开这个页面，获取我在 Make 公开分享的自动化模板：

[即刻个人动态归档 | Make HQ](https://sspai.com/link?target=http%3A%2F%2Fwww.make.com%2Fen%2Fintegration%2F11176-%3FtemplatePublicId%3D11177)

点击左侧的 **Start guided setup**，进入带引导的设置流程：

![](https://proxy-prod.omnivore-image-cache.app/0x0,siLa1eNw35nYEtRdSTf4BwxpffsqbquKb-EVnQnujNW0/https://cdn.sspai.com/2023/10/11/aea3103c979eccc877c5024c604e7994.png)

**第 1 步**，需要你输入自己的移动版即刻主页链接，以便自动化获取你的动态内容：

![](https://proxy-prod.omnivore-image-cache.app/0x0,s49jIAWxrfNauL-T9OdDA-N-GrFIgvvH5A0lGno7_g3I/https://cdn.sspai.com/2023/10/11/a1d9a4f34bff3419eae87ec2d9a15a5d.png)

要获取即刻主页链接，可以在即刻 app 中依次点击：**我 > 右上角分享按钮 > 复制链接**，随后粘贴到这里。

**第 2 步**，需要将 Make 连接到自己的 Notion，并在这里的下拉菜单选择 **Public connection**，连接的方法推荐参考 [Make 官方文档](https://sspai.com/link?target=https%3A%2F%2Fwww.make.com%2Fen%2Fhelp%2Fapp%2Fnotion%3F%23establish-a-notion-public-connection) ：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sQ0alQe3exsJcq1jIQtCpxgK8mj0ttFZc0lPjhc9Ekps/https://cdn.sspai.com/2023/10/11/9c4c2bd789e0c2be61a073c2b77cc6bc.png)

成功连接后，下面应该会出现 Database ID 一栏，这里需要输入你复制到 Notion 的数据库的 ID：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sF5hEXND8TlNSfCWhSjA0Ebzr75y6liOqLL5KlkCH_j4/https://cdn.sspai.com/2023/10/11/6f2dae132b874a8f7f3242a1a05162c1.png)

你可以点击 Search 按钮，输入数据库的名称搜索，正确的情况下，这里的 ID 应该和你数据库链接的中的 ID 一致，见下面链接的加粗部分：

> https://www.notion.so/mrkwtkr/**7a0f625c7c264692955071b872d7cf1e**?v=7284d04c64494edf80bbc32f0ee5c40a&pvs=4

小提示：要获取 Notion 页面的链接，可以在打开页面时用快捷键 `Ctrl/Cmd+L`，页面链接就会复制到剪贴板了。

**第 3 步**，也涉及到配置 Notion 连接和数据库 ID，这部分和前面一样

![](https://proxy-prod.omnivore-image-cache.app/0x0,sAXwteAWw89NTMTzdCag__nXptvRPjNJafmyz40lk18Y/https://cdn.sspai.com/2023/10/11/0f8fa10f7d20a45e6ce0850d58ce8a55.png)

至此，基础的引导就过完了，距离大功告成就剩最后两步：配置查询与新建页面的模块。

## 3\. 配置查询与新建页面的模块

首先是查询规则，点击从左往右第一个 Notion 模块，打开配置菜单：

![](https://proxy-prod.omnivore-image-cache.app/0x0,su2uA61GDNUPp57pk5efciWNcbwp-3XSyyDkwnf0dIQU/https://cdn.sspai.com/2023/10/11/e18e06c8f119e5853ed176b26b5962ad.png)

这个模块用于新建 Notion 页面的去重，先用即刻动态 ID 在 Notion 数据库中搜索，找有无链接包含 ID 的页面、没有则新建，因此需要我们将查询的规则设为「URL 文本包含 id」，如下图所示：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sPt-y-tfYCqgMvadpBql_O2YKKz7KhDQQ7aXmWsZ0qoI/https://cdn.sspai.com/2023/10/11/297e2c5a000acee2ab0a8f1845665c69.png)

这里的 ID 要选择 Flow Control 流程下最顶层的 `id`，注意不要选错了：

![](https://proxy-prod.omnivore-image-cache.app/0x0,shVFDXCuQkGiPzy8Dr--4A4osBUG1ny31ZwYquETTTlk/https://cdn.sspai.com/2023/10/11/bd6c80607254348baab966fa88d48b78.png)

完成后点 OK 保存改动：

![](https://proxy-prod.omnivore-image-cache.app/0x0,s4ku4-AEq2ZAFvtH6WfsRgp6S9KrDlrm6wmAadET57q4/https://cdn.sspai.com/2023/10/11/dc84f791a3b3fbcfba75a0106038d38e.png)

接着，来配置新建页面的数据映射，点最右边这个 Notion 模块，打开配置菜单：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sCxzuv3TGMhKVdWRtGMDXbjUxK4w6wUVLu2CZDLP8gzE/https://cdn.sspai.com/2023/10/11/7f51cc24584145dc662d105967ea1357.png)

在 Fields 分区下，可见标题已经配置好了，但还有 5 项属性需要额外配：

* 发布时间
* 转发
* 点赞
* 正文
* URL

![](https://proxy-prod.omnivore-image-cache.app/0x0,sPaFmP5xhuBFcV63iF9NeFBG5bafzpatuPZ44XyaSLro/https://cdn.sspai.com/2023/10/11/73021232dc9763a35702c20079ae3746.png)

为了拿到正确的数据，我们先点击左下角的 **Run once**，运行一次自动化：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sE7mqRrPjEBI0UyB2dZDZ3q2XlC1HN_ZyWjrvt7IzyA0/https://cdn.sspai.com/2023/10/11/eed8f2131e6ed2890001fc173abc67ff.png)

运行后，Notion 数据库中就会出现我们最近发过的动态了，但标题以外的数据都是空的，因为我们还没配置好，先删掉这些测试的页面继续：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sOjvYq6sDB_39YVccbnmUSqCCuYDqp2u2cNleFqPPZNM/https://cdn.sspai.com/2023/10/11/6a294c1dd1e0766f62e84b31209c526f.png)

回到 Make 页面，点击**发布时间 > Start Time** 下面的输入框，搜索 **createdat**，选择 Flow Control 下最顶层的 `createdAt`：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sCpcYX8DlN-na1Jhy4DRV-8XXMiJ2KgtTMDF84GJ78ng/https://cdn.sspai.com/2023/10/11/e9ecb83a3b7d21795d56f7a6e12f2c3a.png)

再滚动往下，**Include Time** 选择 **Yes**，这样记入 Notion 的数据就会精确到发布时间了：

![](https://proxy-prod.omnivore-image-cache.app/0x0,saEQ6PfFAccZ2dypfJpL765piPbFatxPAS1EKUZCHGaE/https://cdn.sspai.com/2023/10/11/12704b7cd6d9f70d924e491313337441.png)

**转发数**，选择 Flow Control 下最顶层的 `repostCount`：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sHrwNS3pUlns6ZgMv4iSRQT5FAfLlMTB1nUD7BVtbKSU/https://cdn.sspai.com/2023/10/11/article/7ac3b11eba95f64aa67ccc2ae169627e?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

**点赞数**，选择 Flow Control 下最顶层的的 `likeCount`：

![](https://proxy-prod.omnivore-image-cache.app/0x0,saZI1YY7JcuDXjyqsc4kCurJdGFDl0XwNkkxzAYoC5KE/https://cdn.sspai.com/2023/10/11/article/29ae53fcd4fa3a8880c15e4e4589e2b6?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

**正文**，也是选 Flow Control 下最顶层的的 `content`：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sQ-51caERHt8I2yF9LdXHMXij-eY-Oh68NSl-Rij94gw/https://cdn.sspai.com/2023/10/11/article/ec08e164344c33b160c1211e3d2560fc?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

**URL** 稍微麻烦点，用到了文本拼接和条件判断，可以复制粘贴下面的内容，将 `type` 和 `id` 都指定为 Flow Control 顶层的同名变量：

```ada
https://web.okjike.com/{{if(4.type = "ORIGINAL_POST"; "originalPost"; "repost")}}/{{4.id}}

```

![](https://proxy-prod.omnivore-image-cache.app/0x0,sS7mcKs614NYBBzEFQ08DHerN1gZZHrheCXWkbOK-MYA/https://cdn.sspai.com/2023/10/11/article/8648a5d50e95b5a926c5fd087fac315b?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

大概解释下这段的含义，已知即刻动态的链接有两种情况，原帖和转发帖。链接开头是固定不变的，结尾追加即刻动态的 ID，中间部分如果读到的 `type` 是 ORIGINAL\_POST 则拼接 originalPost，不是则拼接 repost。

![](https://proxy-prod.omnivore-image-cache.app/0x0,s_iN33fbfixOMN1-rwV47-3G8WVIRyKqLRxHRaA234Bg/https://cdn.sspai.com/2023/10/11/article/cce4455f4360527067ef798004112f21?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

都配置好后点 OK 保存，然后运行自动化，如果目前为止操作无误，过一会你的 Notion 里应该就有数据了：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sO_rYicVk85VSQ6vbGPKhFXuRI0mj8zSBo3UeBwL_2Hw/https://cdn.sspai.com/2023/10/11/article/19195cae97a312789944d754f7fb672b?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

要想数据每天更新怎么办？点左下角的 **Every 15 minutes**，设置每天指定时间运行，再打开定时开关即可：

![](https://proxy-prod.omnivore-image-cache.app/0x0,sk--WVXksoDx5jFGflmqhrBP1TTVLJoTEv4Qe6tLgA_8/https://cdn.sspai.com/2023/10/11/article/613bfa674f825a7987009c430dcd6fde?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

![](https://proxy-prod.omnivore-image-cache.app/0x0,sEO_ctHe431eySqLdxNMQY27ucZuex_YtEVE4SsCWChI/https://cdn.sspai.com/2023/10/11/article/dc6560ef3007d3e75a40b943f190a04c?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

![](https://proxy-prod.omnivore-image-cache.app/0x0,s9FcuBlbDxFK9tvXbQ4RObzUfWatwvJyQVivCD_Mx1DE/https://cdn.sspai.com/2023/10/11/article/f549c49567cb642f8f6b887ad4eb0094?imageView2/2/w/1120/q/90/interlace/1/ignore-error/1)

至此，就完成了这套自动化的搭建和启用。

使用过程中遇到了问题、或想了解更多自动化技巧？欢迎评论或私信交流\~

[![MrCoffeeTalker](https://proxy-prod.omnivore-image-cache.app/0x0,sWsrKlw-BnP1WG_bK07l-LSmyy7d9kV4KnQjN0HZy32o/https://cdn.sspai.com/2022/05/21/d214d57214ec0c49808c3482f0434d97.jpg?imageMogr2/auto-orient/quality/95/thumbnail/!84x84r/gravity/Center/crop/84x84/interlace/1)](https://sspai.com/u/g52evo9a/updates)

 工作是玩和研究游戏，爱好是学习。想帮更多人走上高效的学习和创作之路。机核、即刻、小红书同名。

---

