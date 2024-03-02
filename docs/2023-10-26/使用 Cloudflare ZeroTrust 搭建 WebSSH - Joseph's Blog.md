---
id: e24ad544-5d01-4fc6-9e12-6cb7ae79fc8f
---

# 使用 Cloudflare ZeroTrust 搭建 WebSSH | Joseph's Blog
#Omnivore

[Read on Omnivore](https://omnivore.app/me/cloudflare-zero-trust-web-ssh-joseph-s-blog-18b6ad4dedc)
[Read Original](https://josephcz.xyz/technology/network/cloudflare-webssh-zerotrust)

[Zikin](https://zikin.org/) 在《[使用 Cloudflare Zero Trust 保护 SSH](https://zikin.org/protection-ssh-with-cloudflare-zero-trust/)》一文中介绍了如何使用 Cloudflare ZeroTrust 保护 SSH 的方法，同时也提供了 [对于网页的保护方法](https://zikin.org/cloudflare-zero-trust/)。本文主要补充使用 Cloudflare SSH CA 替代 SSH 公钥的使用方法，以及在部署实践中值得注意的地方。

使用 Cloudflare SSH CA 替代 SSH 公钥，可以使用 GitHub 账户或其他 OpenID Connect 方式登录您的服务器 SSH，而无需私钥或 SSH 密码。这样可以避免私钥泄漏、忘记携带私钥，对于团队统一管理多个服务器、多个用户、分配不同的服务器权限也十分有用。

由于此方法也无需在 Cloudflare WebSSH 界面输入私钥或密码，对于不信任 Cloudflare 传输私钥的场景，也可以使用此方法。

## [](#部署中的注意事项 "部署中的注意事项")部署中的注意事项

1. 对于非 HTTP 应用，Tunnel 需要占用整个域名——不能将 WebSSH 部署在子路径下。
2. 对于多个服务器部署，不可以将多个服务器连接到同一个 Tunnel。需要为每个服务器创建单独的 Tunnel。
3. 对于多个服务器部署，不可以多个域名共用一个 Application。
4. 不可用使用四级及以上域名（如 `server.ssh.example.com`）。Cloudflare 不会为四级及以上域名签发 SSL 证书。必须使用三级域名（如 `server-ssh.example.com`）。
5. 对于 Arch Linux，删除 Tunnel 之后需要执行 `rm /etc/systemd/system/cloudflared*` 删除残留的服务文件。
6. 即是使用 Passkey 登录 GitHub 来通过 Cloudflare ZeroTrust 认证，Cloudflare 依然不认为登录方式为 `fido2`——除非您使用付费的登录管理平台（如 Okta、Duo 等）。因此请不要在登录策略中添加登录方式为 `fido2` 的要求。
7. 您的邮箱前缀（如 `luotianyi@example.com` 的前缀是 `luotianyi`）必须与您的 Linux 用户名相同。否则 Cloudflare ZeroTrust 认证会失败。

## [](#将服务器连接到-Cloudflare-Tunnel "将服务器连接到 Cloudflare Tunnel")将服务器连接到 Cloudflare Tunnel

此部分的操作可参照 Zikin 的 [使用 Cloudflare Zero Trust 保护 SSH](https://zikin.org/protection-ssh-with-cloudflare-zero-trust/)。鉴于 Cloudflare ZeroTrust 控制台有所变化，此处做一定的简述。

操作步骤如下：

1. 打开 [Cloudflare ZeroTrust 控制台](https://one.dash.cloudflare.com/)。
2. 左侧侧边栏选择 **Access** \-> **Tunnels**。点击按钮 **Create a tunnel**。
3. 按照 Cloudflare 的提示，在服务器上安装 Cloudflare Tunnel。  
   * 对于 Arch Linux，可以直接使用命令 `pacman -S cloudflared` 安装并使用命令 `cloudflared service install <token>` 安装。
4. 在 _Add public hostname for_ 页面，设置用于 WebSSH 的子域名。  
   * **Service** 部分 **Type** 选择 SSH  
   * **Service** 部分 **URL** 填写 `127.0.0.1:22`，其中 `22` 为 SSH 服务的端口号  
   完成 Tunnel 的创建。
5. 左侧边栏选择 **Access** \-> **Applications**。点击按钮 **Create an application**。
6. **Select Type** 页面：类型选择 Self-hosted，进入下一页。
7. **Configure App** 页面：  
   * **Application Name** 随便选择  
   * **Application Domain** 设置为刚刚填写的、用于 WebSSH 的子域名
8. **Add Policy** 页面：  
   * **Policy Name** 随便选择  
   * **Configure Rules**  
         * **Selector** 选择 **Emails**  
         * **Value** 填写你自己的电子邮箱（如果您使用 GitHub 登录，应该填写你的 GitHub Primary Email）
9. **Setup** 页面  
   * 在 **Additional settings** 中选择 **Enable automatic cloudflared authentication**  
   * 开启 **Browser rendering**

**注意本文和引用 Zikin 文章中的不同之处**

在 **Add Policy** 页面，如果您希望统一管理自己的多个账号，或多个组织中的不同账号，请参见 Zikin 文中的方法创建 Group。如果您的 WebSSH 仅供自己使用、且验证方式唯一，使用本文的方法可以简化操作。

[![Add Policy 页面的 Configure Rules 配置](https://proxy-prod.omnivore-image-cache.app/0x0,sqz-U0bf9ZMWsVtfegHk_GFaKY50Q_b-T_HU6-1U1aeY/https://blog-static-1251131545.file.myqcloud.com/post/2023/10-25-cloudflare-webssh-zerotrust/configure-rules.jpg?imageMogr2/format/webp/rquality/80/interlace/1)](https://blog-static-1251131545.file.myqcloud.com/post/2023/10-25-cloudflare-webssh-zerotrust/configure-rules.jpg?imageMogr2/format/webp/rquality/80/interlace/1 "Add Policy 页面的 Configure Rules 配置")Add Policy 页面的 Configure Rules 配置

在 **Setup** 页面，对于 **Enable automatic cloudflared authentication** 配置：

* 如果不需要 Cloudflare SSH CA 管理 SSH 认证（不自动登录 SSH），则与 Zikin 文章中保持一致，不打开此项目
* 如果需要 Cloudflare SSH CA 管理 SSH 认证（自动登录 SSH），则需要打开此项目

[![Setup 页面的配置](https://proxy-prod.omnivore-image-cache.app/0x0,sgTBkBRLiEG1tv36fNOgxT18QkP7UdD-7nEYTctkSUN4/https://blog-static-1251131545.file.myqcloud.com/post/2023/10-25-cloudflare-webssh-zerotrust/setup.jpg?imageMogr2/format/webp/rquality/80/interlace/1)](https://blog-static-1251131545.file.myqcloud.com/post/2023/10-25-cloudflare-webssh-zerotrust/setup.jpg?imageMogr2/format/webp/rquality/80/interlace/1 "Setup 页面的配置")Setup 页面的配置

## [](#配置-Cloudflare-SSH-CA "配置 Cloudflare SSH CA")配置 Cloudflare SSH CA

在完成上述配置后，便可以创建 Cloudflare SSH CA 并配置认证。

操作步骤如下：

1. 打开 [Cloudflare ZeroTrust 控制台](https://one.dash.cloudflare.com/)
2. 左侧侧边栏选择 **Access** \-> **Service Auth**。
3. 在上方 Tab 选择栏中，选择 **SSH**
4. 在 **Application** 下拉菜单，选择前一节中创建的 Application。  
[![为 Application 创建 SSH CA](https://proxy-prod.omnivore-image-cache.app/0x0,sgI2DfMMcT2oovjNnmNNXjDxYm5H-NOlRd_aC0R2PR54/https://blog-static-1251131545.file.myqcloud.com/post/2023/10-25-cloudflare-webssh-zerotrust/service-auth-create-ca.jpg?imageMogr2/format/webp/rquality/80/interlace/1)](https://blog-static-1251131545.file.myqcloud.com/post/2023/10-25-cloudflare-webssh-zerotrust/service-auth-create-ca.jpg?imageMogr2/format/webp/rquality/80/interlace/1 "为 Application 创建 SSH CA")为 Application 创建 SSH CA
5. 点击 **Generate Certificate** 按钮，生成 SSH CA。
6. 生成成功后，在下方会看到已经生成 SSH CA 的 Application 列表。点击 Application 的名称，复制弹出窗口中的 Public Key。此 Public Key 即为 SSH CA 公钥。  
[![复制 SSH CA 公钥](https://proxy-prod.omnivore-image-cache.app/0x0,sFG_UlLzTUxuEtJ_HGKUaKHIysEvqPDgGQ7Q52EfEiqs/https://blog-static-1251131545.file.myqcloud.com/post/2023/10-25-cloudflare-webssh-zerotrust/get-ssh-public-key.jpg?imageMogr2/format/webp/rquality/80/interlace/1)](https://blog-static-1251131545.file.myqcloud.com/post/2023/10-25-cloudflare-webssh-zerotrust/get-ssh-public-key.jpg?imageMogr2/format/webp/rquality/80/interlace/1 "复制 SSH CA 公钥")复制 SSH CA 公钥

## [](#配置服务器 "配置服务器")配置服务器

登录服务器，编辑 `/etc/ssh/sshd_config`。确保您已经开启了 `PubkeyAuthentication`：

| 1 | PubkeyAuthentication yes |
| - | ------------------------ |

同时，配置 Cloudflare SSH CA 的路径：

| 1 | TrustedUserCAKeys /etc/ssh/cloudflare-ca.pub |
| - | -------------------------------------------- |

然后，将您在上一步中复制的 SSH CA 公钥保存到 `/etc/ssh/cloudflare-ca.pub`。您可以修改 Cloudflare SSH CA 的存放路径，只要保证 `sshd` 有访问权限即可。

然后，重新启动 SSH 服务：

| 1 | systemctl restart sshd |
| - | ---------------------- |

* _注：不同发行版的 SSH 服务名称可能不同，可能为 `ssh`、`sshd`、`openssh-server` 或其他名称。对于不使用 Systemd 的发行版，请参考其手册或文档。_

此时打开您设置的 WebSSH 域名，即可看到 Cloudflare ZeroTrust 的登录界面。登录后，无需输入私钥或密码，即可访问您的服务器 Shell。

## [](#Cloudlfare-相关的文档 "Cloudlfare 相关的文档")Cloudlfare 相关的文档

1. Cloudflare 社区上对于多个服务器连接到同一个 Tunnel 的讨论：[Multiple SSH servers under same tunnel name?](https://community.cloudflare.com/t/multiple-ssh-servers-under-same-tunnel-name/420170)
2. Cloudflare 文档：[SSH](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/use-cases/ssh/)
3. Cloudflare 文档：[Configure short-lived certificates](https://developers.cloudflare.com/cloudflare-one/identity/users/short-lived-certificates/)

---

