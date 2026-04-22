**WSL（Windows Subsystem for Linux）既能免去安装双系统或配置复杂虚拟机的麻烦，又能提供与原生 Ubuntu 高度一致的终端操作体验 。

### 为什么推荐 WSL？

WSL 的核心优势在于**无缝集成**与**轻量便捷**，这在教学场景中尤为实用：

*   **真正的 Ubuntu 内核**：WSL 2 运行的是完整的 Linux 内核，这意味着在课堂上讲授的 `ls`, `cd`, `mkdir`, `chmod` 等命令，其行为、参数与原生 Ubuntu **100% 一致**
*   **极低的环境搭建成本**：无需制作 U 盘启动盘或修改 BIOS 启动项，只需在 Windows 终端（PowerShell）中输入 `wsl --install` 即可自动完成安装，几分钟内就能得到一个开箱即用的 Ubuntu 终端 。
*   **文件互通的便利性**：代码或课件可以放在 Windows 文件夹下，通过 `/mnt/c/` 路径直接在 Ubuntu 终端中访问但是跨系统操作大文件时性能略低 。

注意以下两点：

1.  **统一要求使用 WSL 2**：
    WSL 1 是简单的兼容层，而 **WSL 2 是真正的 Linux 虚拟机**。像 `snap` 安装软件、`systemctl` 服务管理等高级操作只能在 WSL 2 下运行。建议让学生检查版本：`wsl -l -v`，确保显示为 Version **2** 。
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

安装 WSL 2 确实需要两个层面的支持：**BIOS/UEFI 层面的硬件虚拟化必须开启**，**Windows 系统层面的虚拟机平台功能也必须启用**。如果任何一层没打开，安装时都会报错“当前计算机配置不支持 WSL2”。

### 📋 两步排查清单

| 步骤 | 检查/操作项 | 具体方法 |
| :--- | :--- | :--- |
| **第一步** | **确认硬件虚拟化已启用** | 打开**任务管理器** (Ctrl+Shift+Esc) -> **性能** -> **CPU**，查看右下角“虚拟化”状态。<br>• **已启用**：万事大吉，直接进入第二步。<br>• **已禁用**：需要重启电脑，进入BIOS/UEFI开启。<br>• **不支持**：说明CPU太老旧，无法使用WSL 2。 |
| **第二步** | **启用Windows功能** | 在PowerShell（管理员）中运行：<br>`dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`<br>`dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`<br>**完成后务必重启电脑**，让功能生效。 |

CPU 不支持虚拟化可以使用WSL 1：**WSL 1 完全可以正常使用，它对硬件虚拟化没有强制要求。**

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

通过图形界面启用Windows功能有两种路径可以找到设置入口：

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


### 1. 命令行前的“小尾巴”不同
*   **Ubuntu**：默认提示符通常是 `用户名@主机名:~$`。
*   **macOS**：默认提示符通常是 `MacBook-Pro:~ 用户名$` 或一个简单的 `%`。
*   **直接忽略 `$` 或 `%` 符号前面的内容**，你只需要关注输入的命令本身即可。比如无论提示符显示什么，输入 `pwd` 然后回车，效果都是一样的。

### 2. 高级操作和课后作业的注意事项
*   **基础命令完全一致**：如 `pwd`, `ls`, `cd`, `mkdir`, `touch`, `cp`, `mv`, `rm`, `cat` 等，在 Mac 终端下的用法、参数和输出结果**完全相同**，无需任何额外配置。
*   **如果涉及 `apt install` (安装软件) 或 `systemctl` (管理系统服务)，Mac 上是跑不通的。


### 1. `df -h`
**作用**：查看**整个文件系统/磁盘分区**的总容量、已用空间、可用空间及挂载点。
**要点**：
- `-h` 是 `--human-readable` 的缩写，作用是把枯燥的字节数自动换算成 **GB、MB** 这种直观单位。
- **场景**：当磁盘满了时，第一步应该是运行 `df -h` 看根分区 `/` 或 `/home` 分区的 **Use%** 是不是到了 100%。

### 2. `du -h --max-depth=1`
**作用**：查看**当前目录下**，所有第一层子目录和文件各自占用的空间大小。
**要点**：
- 你提到的 `--depth = 1` 存在拼写错误，正确的参数是 **`--max-depth=1`**（注意是短横线，不是空格，且中间无空格）。
- `-h`：同样表示自动显示为 KB、MB、GB。
- **场景**：当 `df -h` 显示磁盘满了，但不知道是哪个文件夹撑爆的，就可以 `cd /` 然后执行这条命令来“抓凶手”。

### 📝 演示示例与对比

| 命令 | 输出示例（解读） | 核心区别 |
| :--- | :--- | :--- |
| `df -h` | `/dev/sda2 98G 50G 43G 54% /` | **宏观视角**：看整个硬盘分区还剩多少空位。 |
| `du -h --max-depth=1` | `1.2G ./Downloads`<br>`300M ./Desktop` | **微观聚焦**：看当前这一层谁的体积最大。 |
| `du -sh *` | `4.5G Ubuntu.iso` | **快速清单**：只看目录内第一级内容的各自总大小。 |

### ⚠️ 避坑提示
1.  **`df` 与 `du` 统计结果不一致怎么办？**
    这是常遇到的现象：`df` 显示已用 100%，但 `du` 扫完根目录加起来只用了 50G。原因通常是**文件被删除但进程未释放**（进程句柄占用）。可以简单带过一句：用 `lsof | grep deleted` 查看是否有“幽灵文件”占着空间不释放。

2.  **`--max-depth` 的易错点**
    提醒学生这是两个短横线 `--`，且等于号紧挨着数字：`--max-depth=1`。如果写成 `-maxdepth 1`（单横线）是 BSD 风格的参数，在 Linux 原生环境下会报错。
由于网络受限无法访问 GitHub 网页，且目标只是练习 `git push` / `git pull` 的本地操作手感，那**共享同一个私钥**具体的操作步骤如下：

### 第一步：公共端准备

1.  **生成一把“公用钥匙”**：
    在你自己的电脑上执行以下命令（为了方便记忆，可以命名为 `class_key`）：
    ```bash
    ssh-keygen -t ed25519 -f ~/.ssh/class_key -C "class_shared_key"
    ```
    *执行过程中一路按回车即可，不要设置密码短语，否则学生每次 Push 都要输密码。*

2.  **获取公钥并添加到 GitHub**：
    -   查看公钥内容：`cat ~/.ssh/class_key.pub`
    -   复制内容，打开 GitHub 网页（你需要用点手段或在自己网络环境下操作）。
    -   进入 **Settings -> SSH and GPG keys -> New SSH Key**，粘贴并保存。

3.  **将私钥文件打包发给学生**：
    -   私钥文件在这里：`~/.ssh/class_key`（**注意是没有 .pub 后缀的那个**）。
    -   你可以把它放到教室的 FTP 或共享文件夹里，让学生下载。

### 第二步：个人端操作（指导学生在命令行执行）

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
