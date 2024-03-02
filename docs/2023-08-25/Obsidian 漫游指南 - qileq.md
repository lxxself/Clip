---
id: bf4be92d-1935-4b59-ab00-688fb38ce795
---

# Obsidian 漫游指南 | qileq
#Omnivore

[Read on Omnivore](https://omnivore.app/me/obsidian-qileq-18a2c2b0bf4)
[Read Original](https://qileq.com/tool/obsidian)

笔者从参加工作到至今陆续使用过几款笔记系统/工具，从最初繁杂但又强大的 Emacs org-mode 到 wiznote、Evernote、OneNote 等富文本编辑器，到 Bear markdown 这种 tag 类型的笔记，再到最近两年多开始使用语雀。语雀一直不断更新新功能，日常使用也能满足我的需求，因此前期感觉这款软件还是蛮不错的。随着时间的推移，在语雀陆陆续续积累了 500 多篇笔记后，发现语雀对知识输入这个环节完成的不错，但对知识提取这块还有些改进空间，具体表现为： 

1. 几个月前记录的笔记，突然某天想查看时，由于笔记太多了，已经想不起来具体位置了，而目前语雀的搜索功能相对而言较弱，经常需要跳到浏览器搜索，这种切换给我带来了不好的体验；
2. 客户端目前仍不支持 tag，需跳转到浏览器端查看和设置。

在经历语雀带给我的几十次提取知识的不流畅感后，笔者尝试打造属于自己的第二大脑，能流畅的完成知识的输入和提取这两个环节。笔者对笔记系统的需求如下： 

1. 支持本地化管理，不依托于笔记官方存储。原因是官方可能因各种原因不再提供服务或倒闭，但此时我需要确保个人笔记不受影响。
2. 支持 tag 管理。这个需求在文件管理中很常见，我们经常会遇到一篇文章该放在哪个目录下的问题，但一个 tag 即能解决这个问题。
3. 搜索功能要强大，毕竟笔记多了之后，会经常需要查找笔记。
4. 支持多平台同步，如 macOS、Windows、手机端等。
5. 支持 markdown。这样不管是发布到个人网站还是 github，基本不需要改动。
6. 支持 todo list 加分，支持模板功能加分。

某天在网上看到 [Obsidian](https://obsidian.md/) 这个工具，其 Slogon 是 “A second brain, for you, forever”，觉得蛮有意思，也刚好能解决自己的几个痛点，可定制化程度也非常高。使用几个月后已经积累了 400 多篇笔记，目前笔者在如下方面都使用了 Obsidian： 

* 记录专业笔记与日常想法
* 工作备忘录
* 每天的日程安排，配置 Reminders 提醒
* TODO list
* 阅读 PDF 等文档并做笔记
* 同步微信读书笔记
* 项目管理
* 学英语
* 写 Blog、写 Newsletter 等
* 同步 Matter 等的标注
* 画 [Excalidraw](https://qileq.com/tool/obsidian/plugins/excalidraw/) 图
* ...

可以说，Obsidian 的可玩性还是蛮高的，但正因为如此，一些朋友沉迷于 Obsidian 的各种优化，真正记录下来的笔记却很少，这里笔者提醒各位勿忘记 Obsidian 只是工具，重要的是积累想法。

在积累 1000 多篇笔记后，笔者越用越感叹 Obsidian 的强大： 

1. 丰富的社区插件  
每次对笔记系统有新的想法时，搜索插件时发现社区基本都有人提供了插件。
2. 碎片知识形成了网状结构  
得益于双链设计，任一笔记可以关联任何多个其他笔记，再结合 tag 系统，很容易找到主题下所有关联的笔记。这种组织形式适合构建自己的知识体系和知识树。

## 简介[​](#简介 "简介的直接链接")

现代笔记管理软件主要有两大类：**目录**管理和**标签**管理软件，两者比较如下：

### 目录管理[​](#目录管理 "目录管理的直接链接")

目录（或文件夹）管理软件即将主要属性相同的文件都放在同一目录下，如“数学”目录存放所有和数学相关的笔记。大部分笔记管理软件都属于目录管理软件，如目前语雀客户端。

![](https://proxy-prod.omnivore-image-cache.app/0x0,s4QXJn_xKuzKNmmsxz0xK8NYQru3tMC4jgzwo5rAXne4/http://cdn.qileq.com/docs/tools/obsidian/obsidian-file-manage.excalidraw.png-imgWatermark) _目录管理类软件_

目录管理类软件从整体结构上对笔记进行管理，侧重于笔记之间的纵向联系，使得笔记系统更加体系化，拓展了笔记的深度。缺点是笔记都是线性存放的：一篇笔记只能位于一个目录下，不同目录下的文件之间并未产生关联，使得笔记之间互相独立。如果笔记的搜索功能较弱，将严重降低一篇笔记被找到的概率。

### 标签管理[​](#标签管理 "标签管理的直接链接")

标签(tag)管理软件可以对一篇笔记添加多个标签，每个标签代表不同的维度。相较目录管理软件而言，标签管理软件提供多属性的管理，看起来更为合理。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sb4MDcSyot0_CJwPXEE8HKweJc7RglUSIiG1LOVG8f4M/http://cdn.qileq.com/docs/tools/obsidian/obsidian-tag-manage.excalidraw.png-imgWatermark) _标签管理类软件_

标签管理类软件强调笔记之间的横向联系，扩展了笔记的广度。缺点是当标签数量达到成百上千后，管理起来会很非常混乱。

比较好的方式是目录管理与标签管理相结合，这样能避免两者的缺点，这也是目前很多笔记软件所使用的方式。但这样仍不够，以笔者使用多款笔记软件的经验来看，即使是目录与标签组合，笔记之间的关联还是还是不够。

### Zettelkasten[​](#zettelkasten "Zettelkasten的直接链接")

[Zettelkasten](https://en.wikipedia.org/wiki/Zettelkasten) 是德国社会学家 [Niklas Luhmann](https://en.wikipedia.org/wiki/Niklas%5FLuhmann) 发明的一种管理笔记方法。Zettel 是德语“纸条”/“卡片”的意思，Kasten 则是“盒子”/“箱子”的意思。Niklas Luhmann 使用 Zettelkasten 方法在30 多年的研究生涯中出版了 50 多本著作和几百篇学术论文，这种方法之所以高效是因为卡片笔记之间能通过索引等信息关联起来了。

![](https://proxy-prod.omnivore-image-cache.app/0x0,sxp6Nb-KgOwqRWeL3raAR_l1K1XMullQNj0MAJXfxpck/http://cdn.qileq.com/docs/tools/obsidian/obsidian-zettelkasten.excalidraw.png-imgWatermark) _Zettelkasten_

Obsidian 就是一个支持 Zettelkasten 的笔记软件，Zettelkasten 的“卡片”即 Obsidian 中的一篇笔记，“索引”即 Obsidian 中的**双向链接**。Obsidian 通过“双向链接” 实现了 Zettelkasten 的管理笔记的方式，点击双向链接就能直接跳转到链接指向的笔记。如有 Note1 和 Note2 两篇笔记，在 Obsidian 中 Note2 可通过 `[[]]` 和 `![[]]` 两种方式与 Note1 发生关联，效果如下：  
![](https://proxy-prod.omnivore-image-cache.app/0x0,stNRnL_KQhkawK7Wk2IDXM5jCs1H3e1Gz2zFBfbKSB8o/https://cdn.qileq.com/docs/tools/obsidian/obsidian-ref-1.png-imgWatermark)

Obsidian 还提供了 Graph view 来展示笔记之间的关系：  
![](https://proxy-prod.omnivore-image-cache.app/0x0,s49ZjG65wtQ3rddH7YInYhbhybrD_ZFiLXlRze1Dinjw/http://cdn.qileq.com/docs/tools/obsidian/ob-graph-view.png-imgWatermark)  
上图每个点都表示一篇笔记，有双向链接关系的笔记都连接起来了，点击某个点即可跳转到该笔记。

Obsidian 的安装很简单，使用起来也比较方便，但想更好的使用 Obsidian，还需要借助各种插件。笔者日常用户的主要功能有[模板](https://qileq.com/tool/obsidian/plugins/template/)、tag、[dataview](https://qileq.com/tool/obsidian/plugins/dataview/) 等，详情见后续文章。

## 相关软件[​](#相关软件 "相关软件的直接链接")

还有一些不错的笔记系统，如： 

* [Roam Research](https://roamresearch.com/)
* [Logseq](https://logseq.com/)
* [Notion](https://www.notion.so/zh-cn)

Obsidian 虽然可玩性高，但以笔者使用经验来说，其仍有一些不便之处： 

* 文件根据文件名自动排序。用户无法通过拖动来调整笔记的顺序，目前的解决方案是通过文件名前加 1，2，3 这样的标记来排序。
* 由于使用 Markdown 文件，所以文本样式不够丰富，许多其他软件系统提供的各种美观功能，在 Obsidian 中都需要自己写脚本或改 css 文件去实现。

* [简介](#简介)  
   * [目录管理](#目录管理)  
   * [标签管理](#标签管理)  
   * [Zettelkasten](#zettelkasten)
* [Obsidian 的使用](#obsidian-的使用)
* [相关软件](#相关软件)

---

