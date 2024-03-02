---
id: 0ffc3d71-fbe1-4e4f-b04f-a73dd9562f92
---

# 家庭负载均衡节点部署 | Hamster
#Omnivore

[Read on Omnivore](https://omnivore.app/me/hamster-18b0d0c0077)
[Read Original](https://buycoffee.top/blog/home-proxy)

[](https://buycoffee.top/blog)

![家庭负载均衡节点部署](https://proxy-prod.omnivore-image-cache.app/0x0,sqBMalK8yZGUD9atnAPq9yTCbKznFFYeDZWeFkqVhyOM/https://cdn.sanity.io/images/hq281a1h/production/205c1bf9cebffc8a3da80fac38e7e35b012a0133-1920x1080.png)

## 家庭负载均衡节点部署

朋友也能用上的负载均衡节点

15次点击9分钟阅读

## [](#98f63c8db400)实现原因

身边的几个朋友有着查查谷歌学术，逛逛ig的需求，但是都对科学上网了解不多且对软件的认知还停在vpn阶段。

因此计划利用家用服务器进行节点的搭建，对外只暴露为vmess节点，内部为多个机场与服务器组成的负载均衡节点，在保障科学上网稳定的同时也可以降低朋友们的学习成本，采用流行的软件进行连接即可。

## [](#ebb6599afac6)最终效果

### [](#860a26771dae)外部节点效果

![](https://proxy-prod.omnivore-image-cache.app/1423x2273,s34vDrhTogjCtLnocbZiinRyt76m8amE2q-yAVoMjy3E/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F291dcc14e6c724a5759a69973e319e39084481e5-1423x2273.jpg&w=3840&q=75)

### [](#126941d28f0c)x-ui面板管理节点界面

![](https://proxy-prod.omnivore-image-cache.app/3314x1934,sOA11tnAFTFcEDJ7YAYeElfK_WAnuqnOWLzL1hwTxueA/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F2f2dd3402a039b901335d161914eed1c83569e01-3314x1934.png&w=3840&q=75)

### [](#22298e35d6b0)v2rayA界面

![](https://proxy-prod.omnivore-image-cache.app/3314x1934,snjn_xfPXRwlknQRTYd06Vh5UIhdCxo8Svb__giAhnMI/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F8d3c20a6f336ff7149e9d42a1c0456bb990c8814-3314x1934.png&w=3840&q=75)

### [](#26e6c13395e5)Uptime Kuma节点监控界面

![](https://proxy-prod.omnivore-image-cache.app/3314x1934,s0mKC1sM7nnxJ3883m2Im3_wCYYNMPNpmluMgbIsRDsc/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2Fb81b450d71f77675c0b05c3644cce54e2c1ce632-3314x1934.png&w=3840&q=75)

### [](#b64db418be63)Bark推送示例

![](https://proxy-prod.omnivore-image-cache.app/1459x2770,sDQmgmX-qc6Vo-Ju--bawFCSegW_ObfPLaGWiTioh6Zg/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2Faba0b91072ac00cc29e9c07a4ef20fae7e4fa97e-1459x2770.jpg&w=3840&q=75)

## [](#e0d4e53d3a99)架构设计

架构为下图所示

在路由器针对单用户节点进行端口转发，在xui中设置出站流量转发至v2raya。

![](https://proxy-prod.omnivore-image-cache.app/3604x842,sTfYSgpH-poSzmM_5sAWpgkvz_kpCvk0UwF436gQEyXU/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F31d07884628dad220d0d6d2496af1088082ad23f-3604x842.png&w=3840&q=75)

## [](#72b304ceec5d)部署环境

在nas上进行部署，配置如下图，配置不高但转发性能远大于家宽上传带宽，因此将就一下也可以。

![](https://proxy-prod.omnivore-image-cache.app/1040x990,sbr1TL8MbPOOfDbmMP0YnheDL2gM5YsQhIaC206zeKxM/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F43b7b07e11e7f895fd2c677f8d68198ff9ab21a8-1040x990.png&w=3840&q=75)

> 全部组件都在Docker上进行部署，便于后续的维护与升级。

![](https://proxy-prod.omnivore-image-cache.app/3702x1534,sLM3KlzdovDa-1eDUuqcuRKmRXghA1jLGiGCNzdUiPms/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F57d23ac9b0cbc3ddbe2ad6e58c4c9d6985e5fa22-3702x1534.png&w=3840&q=75)

## [](#afeae7dc0a60)v2raya搭建

**项目地址** <https://github.com/v2rayA/v2rayA>

本次项目的核心负载均衡部分由开源项目v2rayA进行控制，v2rayA 是一个支持全局透明代理的 V2Ray Linux 客户端，同时兼容SS、SSR、Trojan(trojan-go)、[PingTunnel](https://github.com/esrrhs/pingtunnel)协议。

### [](#a9fb58737947)采用Docker进行部署v2rayA

采用Docker进行部署。在本项目中由于我们主要将v2rayA用以对外服务，因此在部署时不采用host模式，手动进行端口的开放。我们只需要开放v2raya管理后台的2017端口以及接收x-ui面板转发socks5流量的20172端口（可自行选择更换）。也可以开放更多端口供后续其他用途。

```basic
1# run v2raya
2docker run -d \
3  -p 2017:2017 \
4  -p 20170-20172:20170-20172 \
5  --restart=always \
6  --name v2raya \
7  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
8  -v /etc/v2raya:/etc/v2raya \
9  mzz2017/v2raya
```

### [](#9678e32a1ab5)管理后台配置

因为v2rayA的用途为节点的负载均衡，因此在设置中可以将分流关闭，对外只作为一个节点，并且将透明代理与系统代理关闭，不进行过多的流量处理。

![](https://proxy-prod.omnivore-image-cache.app/1372x1156,sKDcwhayOfeIBC05Zl2P0xIjCfPzfs4TOGm-Nsmgi874/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F4f808fc2961b54aaeb084bfaf922cac84d98da4d-1372x1156.png&w=3840&q=75)

> 在设置中开启端口分享，在地址与端口中将socks5端口绑定到Docker部署时开放的端口。

![](https://proxy-prod.omnivore-image-cache.app/1400x1274,snLKwR8VPKK0oPP7miMuZPx1eO21msCxuVKEAwDIOguM/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2Fac7fe89d68e20d8b91ffd148e7529ab31bc2d35a-1400x1274.png&w=3840&q=75)

### [](#8451f6f42636)节点的添加与负载均衡

v2rayA可以添加服务器与订阅多种使用节点的方式，点击创建为新建单节点，点击导入则为订阅。

在添加完节点与订阅后，只需点击节点后的选择，即为加入负载均衡列表中。

![](https://proxy-prod.omnivore-image-cache.app/2652x1788,s1-Ftp29Iqt9byvievuVL_ajquPf8nMevOyaI2kzlfMc/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F301e73286cc444c060a2ffbef8cc5f7aeb036d43-2652x1788.png&w=3840&q=75)

负载均衡的原理为针对每个节点进行延迟的测试，自动连接延迟最低的节点进行使用。在PROXY中可以配置延迟测试的站点，测试间隔时间。

![](https://proxy-prod.omnivore-image-cache.app/1328x1054,sSzqmr-CpgUQdtZeuJbbq9crHL6ZOVymzrWSZm1eLVsk/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2Fe68615c710f25d14bd95674961e2f0b49ec60e9e-1328x1054.png&w=3840&q=75)

配置完成后，点击左上角运行按钮，等待显示正在运行蓝色按钮即配置完成。也可在左边栏中查看当前节点连接情况与延迟。

![](https://proxy-prod.omnivore-image-cache.app/832x1862,sjl7a443cMpY95TG5spRTLy0c-78v19xKwxL7cWSfs5E/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F51b995482cf1e373e90ea86ff89d7f5dfe5f75e0-832x1862.png&w=1920&q=75)

## [](#6b3d211a2654)x-ui搭建

x-ui为一个支持多协议多用户的xray面板，在项目中只要用作对外开放节点的管理以及将出口流量转发至v2rayA。

### [](#ddda5316fbf6)采用Docker进行部署x-ui

在部署x-ui时，采用host模式进行部署，避免后续节点新增带来的端口映射问题。

```basic
1mkdir x-ui && cd x-ui
2docker run -itd --network=host \
3    -v $PWD/db/:/etc/x-ui/ \
4    -v $PWD/cert/:/root/cert/ \
5    --name x-ui --restart=unless-stopped \
6    enwaiax/x-ui:latest
```

### [](#36342552d3ae)管理后台配置

因为v2rayA的用途为节点的负载均衡，因此在设置中可以将分流关闭，对外只作为一个节点，并且将透明代理与系统代理关闭，不进行过多的流量处理。

![](https://proxy-prod.omnivore-image-cache.app/1372x1156,sKDcwhayOfeIBC05Zl2P0xIjCfPzfs4TOGm-Nsmgi874/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F4f808fc2961b54aaeb084bfaf922cac84d98da4d-1372x1156.png&w=3840&q=75)

> 在设置中开启端口分享，在地址与端口中将socks5端口绑定到Docker部署时开放的端口。

![](https://proxy-prod.omnivore-image-cache.app/1400x1274,snLKwR8VPKK0oPP7miMuZPx1eO21msCxuVKEAwDIOguM/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2Fac7fe89d68e20d8b91ffd148e7529ab31bc2d35a-1400x1274.png&w=3840&q=75)

### [](#005d9cba0778)节点的添加与负载均衡

v2rayA可以添加服务器与订阅多种使用节点的方式，点击创建为新建单节点，点击导入则为订阅。

在添加完节点与订阅后，只需点击节点后的选择，即为加入负载均衡列表中。

![](https://proxy-prod.omnivore-image-cache.app/2652x1788,s1-Ftp29Iqt9byvievuVL_ajquPf8nMevOyaI2kzlfMc/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F301e73286cc444c060a2ffbef8cc5f7aeb036d43-2652x1788.png&w=3840&q=75)

负载均衡的原理为针对每个节点进行延迟的测试，自动连接延迟最低的节点进行使用。在PROXY中可以配置延迟测试的站点，测试间隔时间。

![](https://proxy-prod.omnivore-image-cache.app/1328x1054,sSzqmr-CpgUQdtZeuJbbq9crHL6ZOVymzrWSZm1eLVsk/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2Fe68615c710f25d14bd95674961e2f0b49ec60e9e-1328x1054.png&w=3840&q=75)

配置完成后，点击左上角运行按钮，等待显示正在运行蓝色按钮即配置完成。也可在左边栏中查看当前节点连接情况与延迟。

![](https://proxy-prod.omnivore-image-cache.app/832x1862,sjl7a443cMpY95TG5spRTLy0c-78v19xKwxL7cWSfs5E/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F51b995482cf1e373e90ea86ff89d7f5dfe5f75e0-832x1862.png&w=1920&q=75)

## [](#daa6832f72e4)x-ui搭建

x-ui为一个支持多协议多用户的xray面板，在项目中只要用作对外开放节点的管理以及将出口流量转发至v2rayA。

### [](#ae48116cde97)采用Docker进行部署x-ui

在部署x-ui时，采用host模式进行部署，避免后续节点新增带来的端口映射问题。

```basic
1mkdir x-ui && cd x-ui
2docker run -itd --network=host \
3    -v $PWD/db/:/etc/x-ui/ \
4    -v $PWD/cert/:/root/cert/ \
5    --name x-ui --restart=unless-stopped \
6    enwaiax/x-ui:latest
```

部署完成后，访问ip:54321进行面板的访问，初始用户名与密码为admin。

登陆完成后，务必修改用户名与密码。

### [](#3a5def2f04f6)x-ui流量转发配置

此步将配置x-ui全部的出站流量转发至v2rayA中，达到采用负载均衡节点的目的。

在面板设置中的xray项目相关设置中进行设置。

```basic
1{
2    "api":{
3        "services":[
4            "HandlerService",
5            "LoggerService",
6            "StatsService"
7        ],
8        "tag":"api"
9    },
10    "inbounds":[
11        {
12            "listen":"127.0.0.1",
13            "port":62789,
14            "protocol":"dokodemo-door",
15            "settings":{
16                "address":"127.0.0.1"
17            },
18            "tag":"api"
19        }
20    ],
21    "outbounds":[
22        {
23            "protocol":"socks",
24            "settings":{
25                "servers":[
26                    {
27                        "address":"192.168.31.93",
28                        "port":20172,
29                        "users":[
30                            
31                        ]
32                    }
33                ]
34            }
35        },
36        {
37            "protocol":"freedom",
38            "tag":"direct",
39            "settings":{
40
41            }
42        },
43        {
44            "protocol":"blackhole",
45            "settings":{
46
47            },
48            "tag":"blocked"
49        }
50    ],
51    "policy":{
52        "system":{
53            "statsInboundDownlink":true,
54            "statsInboundUplink":true
55        }
56    },
57    "routing":{
58        "rules":[
59            {
60                "inboundTag":[
61                    "api"
62                ],
63                "outboundTag":"api",
64                "type":"field"
65            },
66            {
67                "ip":[
68                    "geoip:private"
69                ],
70                "outboundTag":"blocked",
71                "type":"field"
72            },
73            {
74                "type":"field",
75                "domain":[
76                    "geosite:cn"
77                ],
78                "outboundTag":"direct"
79            },
80            {
81                "type":"field",
82                "ip":[
83                    "geoip:cn"
84                ],
85                "outboundTag":"direct"
86            },
87            {
88                "outboundTag":"blocked",
89                "protocol":[
90                    "bittorrent"
91                ],
92                "type":"field"
93            }
94        ]
95    },
96    "stats":{
97
98    }
99}
```

核心在outbounds中，进行协议的配置与目标服务器ip与端口的配置，此处填入服务器内网ip与socks5端口即可。

![](https://proxy-prod.omnivore-image-cache.app/884x690,sDOWEIgiQpI-iNuQZHJi8xwzJIUCQZyBOwYnzyijcQGs/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F4519295e3d065fd40c82df9e6f3a6d0a73211039-884x690.png&w=1920&q=75)

### [](#ccb12dc8db14)添加节点进行测试

在入站列表进行对外节点的添加，选择vmess协议，端口随机生成，其余配置不变点击添加。

![](https://proxy-prod.omnivore-image-cache.app/1182x1338,sZPNd2JIfgtJrKk0rYP1AqBuHvJk0FR883iYL2PDErzY/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F796d14a73a6c70f15ad1ef7d73d0b45c7db09f17-1182x1338.png&w=3840&q=75)

可以利用软件扫描节点二维码进行连接测试。

![](https://proxy-prod.omnivore-image-cache.app/1068x660,scXUsF7NAJwb2AhZFzvGJTVvDWDXMeaPhkmrZBhxjgtA/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2Fa03c7b1e16c2c189a9ca440e8d276caf2cd344de-1068x660.png&w=3840&q=75)

## [](#fa789c87e255)DDNS

在上述组件配置完成后，最后一步则是进行域名的配置，因为家宽的ip通常在72小时会进行重新拨号获取，因此采用DDNS用于动态域名解析，省去手动更换ip进行连接的使用成本。

本项目采用DDNS-Go进行动态解析。在Domains中填入需要动态解析的域名即可。IP变更通知配置可采用bark推送进行通知。

![](https://proxy-prod.omnivore-image-cache.app/3384x2010,sSkrV35Fd5pyQvIA69IpK6GVaIZSv0E5BpzZfysLsV5w/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F60721a87a15c8ed07814f5412af7d016c5480093-3384x2010.png&w=3840&q=75)

## [](#7ebd61e4c280)路由器进行端口转发并通过域名进行节点连接

在路由器后台针对单节点进行端口转发即可用域名加端口的方式进行节点连接。

![](https://proxy-prod.omnivore-image-cache.app/2732x1468,sKqq7lTtKs7YjWILbyN7oA_AYbUGYUKAhpu9EbAA3rG0/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2Fee05a11ff489b50c35f68ffaf9bd8a39a5ce029b-2732x1468.png&w=3840&q=75)

## [](#cf41a3adc631)节点监控

采用uptimekuma进行节点的监控，采用bark进行推送。

在xui新建一个加密的sock5节点（**_注意⚠️：这种方式并不安全_**），记录信息后在uptimekuma中进行创建新监控服务。

![](https://proxy-prod.omnivore-image-cache.app/1172x1008,sltXU9rTwyJk1_ohkgpwOduzUocqa7Nkn0kj4H6F8nn4/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2Fddb6094d9e112f05bd231374376eca226be7b159-1172x1008.png&w=3840&q=75)

![](https://proxy-prod.omnivore-image-cache.app/1102x1736,s9wvpaUxZPKwOw8Gqk_M_vjosOckqpagRCrEVTfHe4Lw/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2Ff9040c411ea2707bb48062e2ea001eb0e6839425-1102x1736.png&w=3840&q=75)

通过检测访问<https://gstatic.com/generate%5F204>进行节点连通性的检测。

![](https://proxy-prod.omnivore-image-cache.app/2212x1500,sMudJBuY-rm0ucWIVGE6fOjTZp-p0g6XYwaNuKyNDMIQ/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F82ad515cf5433569d02baa3ec98cb811b09f4e7a-2212x1500.png&w=3840&q=75)

### [](#fb4806c40bed)节点通知

采用bark进行节点状态的通知，关于推送配置可直接使用Uptime Kuma中的bark配置或BarkPush-Go进行多设备统一推送，此项目仍在完善中，请关注后续文章。

![](https://proxy-prod.omnivore-image-cache.app/1284x2138,sDDlb7LeeI7neuZo2GHZrX6Z-iXlI5QY0_o2_u4i8sKM/https://buycoffee.top/_next/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fhq281a1h%2Fproduction%2F1586745255d786ea95d8fb6b71dd43f1e2ba8d97-1284x2138.png&w=3840&q=75)

## [](#5f68c4c91ffa)服务器监控

最后可以针对nas整体进行状态的监控，本项目采用哪吒探针进行监控。

<https://github.com/naiba/nezha>

![](https://proxy-prod.omnivore-image-cache.app/558x200,suNkXgoIhBY3YWRexBJ9BvCI25gl7emyJTIInfcSPaH0/https://cdn.sanity.io/images/hq281a1h/production/26812545be71d9516218ed4419b21e172bed6d4f-558x200.svg)

## [](#9760085b1372)最后的话

谢谢你看到这里🙏。

生命不息，折腾不止。

如有任何疑问与建议请留言～每条留言都会用心回复。  

---

