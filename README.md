## WSL（Windows Subsystem for Linux）
** 该系统既能免去安装双系统或配置复杂虚拟机的麻烦，又能提供与原生 Ubuntu 高度一致的终端操作体验。

### 为什么推荐 WSL？

WSL 的核心优势在于**无缝集成**与**轻量便捷**：

*   **真正的 Ubuntu 内核**：WSL 2 运行的是完整的 Linux 内核，这意味着 `ls`, `cd`, `mkdir`, `chmod` 等命令，其行为、参数与原生 Ubuntu **100% 一致**
*   **极低的环境搭建成本**：无需制作 U 盘启动盘或修改 BIOS 启动项，只需在 Windows 终端（PowerShell）中输入 `wsl --install` 即可自动完成安装，几分钟内就能得到一个开箱即用的 Ubuntu 终端 。
*   **文件互通的便利性**：代码或文件可以放在 Windows 文件夹下，通过 `/mnt/c/` 路径直接在 Ubuntu 终端中访问但是跨系统操作大文件时性能略低 。

注意以下两点：

1.  **统一要求使用 WSL 2**：
    WSL 1 是简单的兼容层，而 **WSL 2 是真正的 Linux 虚拟机**。像 `snap` 安装软件、`systemctl` 服务管理等高级操作只能在 WSL 2 下运行。建议让使用者检查版本：`wsl -l -v`，确保显示为 Version **2** 。
2.  **强调文件存放位置**：
    提醒：**“不要把代码放在 `/mnt/c/`（Windows 目录）下编译运行。”** 跨文件系统读写会导致速度变慢甚至权限错误。正确做法是把项目文件放在 WSL 自己的家目录（`/home/用户名/`）下，这是最流畅、最标准的 Linux 体验 。

### 可参考的命令清单

WSL 终端完全兼容以下常用命令 ：

**系统与路径命令**
*   `pwd`：查看当前所在目录
*   `whoami`：查看当前登录用户名
*   `sudo apt update`：更新软件源列表

**目录操作命令**
*   `cd /home/student`：绝对路径跳转
*   `cd ..` 或 `cd -`：返回上级或上次目录
*   `mkdir my-project`：新建目录

**文件操作命令**
*   `touch hello.txt`：新建空文件
*   `cp file1 file2`：复制文件
*   `mv file1 file2`：移动或重命名文件
*   `rm -r folder/`：删除目录（需谨慎讲解 `-r` 参数）

**权限命令**
*   `chmod 755 script.sh`：赋予可执行权限
*   `chown user:group file`：更改文件属主

### WSL 2 安装注意事项

安装 WSL 2 确实需要两个层面的支持：**BIOS/UEFI 层面的硬件虚拟化必须开启**，**Windows 系统层面的虚拟机平台功能也必须启用**。如果任何一层没打开，安装时都会报错“当前计算机配置不支持 WSL2”。

### 📋 两步排查清单

| 步骤 | 检查/操作项 | 具体方法 |
| :--- | :--- | :--- |
| **第一步** | **确认硬件虚拟化已启用** | 打开**任务管理器** (Ctrl+Shift+Esc) -> **性能** -> **CPU**，查看右下角“虚拟化”状态。<br>• **已启用**：万事大吉，直接进入第二步。<br>• **已禁用**：需要重启电脑，进入BIOS/UEFI开启。<br>• **不支持**：说明CPU太老旧，无法使用WSL 2。 |
| **第二步** | **启用Windows功能** | 在PowerShell（管理员）中运行：<br>`dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`<br>`dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`<br>**完成后务必重启电脑**，让功能生效。 |

### ⚙️ 实操指南：如何在BIOS/UEFI中开启虚拟化

如果任务管理器显示“虚拟化”为“已禁用”，可按以下方法操作：

1.  **进入BIOS/UEFI**
    重启电脑，在屏幕亮起时**反复按**特定按键，常见的是 `F2`、`F10`、`Delete` 或 `Esc`。
    > **通用技巧**：如果不知道按哪个键，可以在Windows中按住 `Shift` 键重启，进入蓝色菜单后选择 **疑难解答 > 高级选项 > UEFI固件设置 > 重启**，也可以进入。

2.  **找到并开启选项**
    进入BIOS后界面各异，需要用键盘方向键导航，在 **Advanced (高级)**、**Configuration** 或 **Security (安全)** 等菜单下，寻找以下关键词并设为 **Enabled (启用)**：
    *   Intel处理器：`Intel Virtualization Technology` 或 `VT-x`
    *   AMD处理器：`SVM Mode` (Secure Virtual Machine)

3.  **保存并退出**
    修改后，按 `F10` 键（通常是保存并退出的快捷键），选择 **Yes** 确认重启即可。

### ⚙️ 实操指南：通过图形界面启用Windows功能有两种路径可以找到设置入口

### 🖥️ 方法一：通过控制面板（Win10 / Win11 通用）
1.  在搜索栏输入"**控制面板**"并打开。
2.  点击"**程序**" -> "**启用或关闭 Windows 功能**"。
3.  在弹出的列表里，找到并勾选以下两项：
    *   **Windows 虚拟机平台** (Virtual Machine Platform)
    *   **适用于 Linux 的 Windows 子系统** (Windows Subsystem for Linux)
4.  点击"确定"并根据提示**重启电脑**。

### ⚙️ 方法二：通过运行命令直达（推荐）
1.  同时按下 `Win + R` 键，打开运行对话框。
2.  输入 `optionalfeatures`，按回车。
3.  同样会打开上方的功能列表窗口，勾选上述两项后重启即可。

### 若第一步排查发现 CPU 不支持虚拟化，则可以使用WSL 1：**WSL 1 完全可以正常使用，它对硬件虚拟化没有强制要求。**

### 核心区别
这是因为 WSL 1 和 WSL 2 的底层工作原理完全不同：
*   **WSL 2**：本质是一个轻量级虚拟机，依赖 Hyper-V 架构，因此**必须**开启硬件虚拟化（Intel VT-x 或 AMD-V）。
*   **WSL 1**：它只是一个“系统调用兼容层”，将 Linux 指令实时翻译给 Windows 内核，**不需要**虚拟机支持，因此可以在没有虚拟化功能的旧 CPU 上运行。

### 安装方法
因为 `wsl --install` 默认会装 WSL 2，你需要按以下步骤**手动指定安装 WSL 1**：

1.  **启用功能**：以管理员身份打开 PowerShell，输入：
    ```powershell
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    ```
2.  **重启电脑**。
3.  **下载并安装 Linux 发行版**：在 Microsoft Store 搜索 Ubuntu 等并安装。
4.  **首次启动时**：它会自动开始安装，默认版本就是 WSL 1（因为未开启虚拟机平台）。

### 功能限制与影响
*   **潜在优势**：WSL 1 访问 Windows 磁盘文件的性能反而比 WSL 2 更好。
*   **已知限制**：WSL 1 不支持 Docker（需虚拟化）、GUI 图形界面和 Snap 等依赖完整内核的特性。

### MacOS 终端操作区别

### 1. 命令行前的“小尾巴”不同
*   **Ubuntu**：默认提示符通常是 `用户名@主机名:~$`。
*   **macOS**：默认提示符通常是 `MacBook-Pro:~ 用户名$` 或一个简单的 `%`。
*   **直接忽略 `$` 或 `%` 符号前面的内容**，你只需要关注输入的命令本身即可。比如无论提示符显示什么，输入 `pwd` 然后回车，效果都是一样的。

### 2. 高级操作和注意事项
*   **基础命令完全一致**：如 `pwd`, `ls`, `cd`, `mkdir`, `touch`, `cp`, `mv`, `rm`, `cat` 等，在 Mac 终端下的用法、参数和输出结果**完全相同**，无需任何额外配置。
*   **如果涉及 `apt install` (安装软件) 或 `systemctl` (管理系统服务)，Mac 上是跑不通的。

## Git SSH Key 相关命令：

## 1. 生成 SSH Key

```bash
# 推荐：生成 Ed25519 密钥（更安全、更快）
ssh-keygen -t ed25519 -C "your_email@example.com"

# 如果系统不支持 Ed25519，使用 RSA 4096
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# 指定文件名和路径
ssh-keygen -t ed25519 -C "your_email@example.com" -f ~/.ssh/id_ed25519_custom
```

## 2. 查看 SSH Key

```bash
# 查看所有 SSH 密钥
ls -la ~/.ssh/

# 查看公钥内容
cat ~/.ssh/id_ed25519.pub
cat ~/.ssh/id_rsa.pub

# 复制公钥到剪贴板
# macOS
pbcopy < ~/.ssh/id_ed25519.pub
# Linux
xclip -sel clip < ~/.ssh/id_ed25519.pub
# Windows (PowerShell)
Get-Content ~/.ssh/id_ed25519.pub | Set-Clipboard
```

## 3. 添加 SSH Key 到 ssh-agent

```bash
# 启动 ssh-agent
eval "$(ssh-agent -s)"

# 添加私钥到 ssh-agent
ssh-add ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_rsa

# 查看已添加的密钥
ssh-add -l

# 删除所有缓存的密钥
ssh-add -D

# 删除指定密钥
ssh-add -d ~/.ssh/id_rsa
```

## 4. SSH 配置文件

```bash
# 编辑 SSH 配置文件
vim ~/.ssh/config
```

配置示例：
```ssh-config
# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519

# GitLab
Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_rsa

# 多个 GitHub 账号
Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work

Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_personal
```

## 5. 测试连接

```bash
# 测试 GitHub 连接
ssh -T git@github.com

# 测试 GitLab 连接
ssh -T git@gitlab.com

# 测试 Gitee 连接
ssh -T git@gitee.com

# 详细调试模式
ssh -vT git@github.com
ssh -vvT git@github.com  # 更详细的输出
```

## 6. 权限设置

```bash
# 设置正确的权限
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519        # 私钥
chmod 644 ~/.ssh/id_ed25519.pub    # 公钥
chmod 600 ~/.ssh/config             # 配置文件
chmod 600 ~/.ssh/authorized_keys    # 授权密钥
```

## 7. 管理多个 SSH Key

```bash
# 使用不同密钥克隆仓库
git clone git@github-work:username/repo.git
git clone git@github-personal:username/repo.git

# 修改现有仓库的远程地址
git remote set-url origin git@github-work:username/repo.git

# 查看远程地址
git remote -v
```

## 8. 常见问题处理

```bash
# 删除旧的主机密钥（连接问题时的解决方案）
ssh-keygen -R github.com

# 转换 SSH2 格式密钥
ssh-keygen -i -f key.pub > key_openssh.pub

# 从私钥提取公钥
ssh-keygen -y -f ~/.ssh/id_ed25519 > ~/.ssh/id_ed25519.pub

# 检查密钥指纹
ssh-keygen -lf ~/.ssh/id_ed25519.pub
ssh-keygen -E md5 -lf ~/.ssh/id_ed25519.pub  # MD5 格式指纹
```

## 9. 完整配置流程

```bash
# 1. 生成密钥
ssh-keygen -t ed25519 -C "your_email@example.com"

# 2. 启动 ssh-agent 并添加密钥
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. 复制公钥
cat ~/.ssh/id_ed25519.pub

# 4. 添加到 GitHub/GitLab（在 Settings → SSH Keys 中粘贴）

# 5. 测试连接
ssh -T git@github.com

# 6. 配置 Git 用户信息
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```

### 由于网络受限无法访问 GitHub 网页，且目标只是练习 `git push` / `git pull` 的本地操作手感，那**共享同一个私钥**具体的操作步骤如下：

### 第一步：公共端准备

1.  **生成一把“公用钥匙”**：
    在你自己的电脑上执行以下命令（为了方便记忆，可以命名为 `class_key`）：
    ```bash
    ssh-keygen -t ed25519 -f ~/.ssh/class_key -C "class_shared_key"
    ```
    *执行过程中一路按回车即可，不要设置密码短语，否则每次 Push 都要输密码。*

2.  **获取公钥并添加到 GitHub**：
    -   查看公钥内容：`cat ~/.ssh/class_key.pub`
    -   复制内容，打开 GitHub 网页（你需要用点手段或在自己网络环境下操作）。
    -   进入 **Settings -> SSH and GPG keys -> New SSH Key**，粘贴并保存。

3.  **将私钥文件打包分发**：
    -   私钥文件在这里：`~/.ssh/class_key`（**注意是没有 .pub 后缀的那个**）。

### 第二步：个人端操作

拿到 `class_key` 文件后，需要完成以下 3 步配置（假设使用 Windows 的 Git Bash 或 Mac/Linux 终端）：

1.  **放置私钥文件**：
    ```bash
    # 假设 class_key 文件下载到了桌面上
    mkdir -p ~/.ssh
    cp ~/Desktop/class_key ~/.ssh/
    chmod 600 ~/.ssh/class_key   # 修改权限，否则 Git 会报错说权限太开放
    ```

2.  **配置 SSH 客户端使用这把钥匙**：
    创建或编辑 `~/.ssh/config` 文件（如果没有就新建一个）：
    ```bash
    # 在 Git Bash 或终端里粘贴以下内容
    cat >> ~/.ssh/config << EOF
    Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/class_key
        StrictHostKeyChecking no
    EOF
    ```
    *最后一行是为了跳过初次连接时的 yes/no 确认，方便课堂流程。*

3.  **测试连接**：
    ```bash
    ssh -T git@github.com
    ```
    看到 `Hi [你的用户名]! ... successfully authenticated` 即表示成功。

### 第三步：回收权限

请务必登录 GitHub，找到刚才添加的那条 SSH Key，点击 **Delete**。

这样操作后，即使手里的 `class_key` 文件没删，也无法再访问你的 GitHub 仓库了。

### ⚠️ 一个需要留意的提醒
因为都在用**同一把锁**的身份（都是你的 GitHub 账号），Git 日志里的 Author 会显示成他们自己电脑上配置的 `git config user.name`。

-   **这会导致一个问题**：如果有人故意把自己的 Git 用户名改成你的名字，然后 `push -f` 强制推送把仓库搞乱，你很难从日志里分辨出到底是谁干的。
-   **应对建议**：可以口头上强调一下，**只允许 `push` 自己的文件，不要覆盖别人的文件**。作为临时的练习环境，通常不会有太大问题。
