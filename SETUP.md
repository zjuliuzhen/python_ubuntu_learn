# 环境配置指南

在 VS Code 中按 `` Ctrl + ` `` 打开终端，输入以下命令：

```bash
bash install.sh

好的，以下是完整的 `SETUP.md`，包含 `install.sh` 一键安装和所有可能遇到的报错及处理指南：

```markdown
# 环境配置指南

## 一句话搞定

在 VS Code 中按 `` Ctrl + ` `` 打开终端，输入以下命令：

```bash
bash install.sh
```

脚本会自动完成所有配置，看到 `✓ 环境配置成功！` 即表示完成。

---

## 目录
- [可能遇到的报错及解决方法](#可能遇到的报错及解决方法)
  - [报错1：python3: command not found](#报错1python3-command-not-found)
  - [报错2：bash: install.sh: No such file or directory](#报错2bash-installsh-no-such-file-or-directory)
  - [报错3：Permission denied (install.sh)](#报错3permission-denied-installsh)
  - [报错4：E: Unable to locate package python3-pip](#报错4e-unable-to-locate-package-python3-pip)
  - [报错5：externally-managed-environment](#报错5externally-managed-environment)
  - [报错6：pip: command not found (安装后仍提示)](#报错6pip-command-not-found-安装后仍提示)
  - [报错7：运行代码时 No module named 'numpy' / 'matplotlib'](#报错7运行代码时-no-module-named-numpy--matplotlib)
  - [报错8：VS Code 右下角没有 Python 版本显示](#报错8vs-code-右下角没有-python-版本显示)
  - [报错9：Code Runner 运行报错](#报错9code-runner-运行报错)
  - [报错10：WSL 中无法连接网络/安装很慢](#报错10wsl-中无法连接网络安装很慢)
  - [报错11：.vscode/settings.json 出现黄色警告](#报错11vscodesettingsjson-出现黄色警告)
- [最终验证](#最终验证)
- [还是不行？](#还是不行)

---

## 可能遇到的报错及解决方法

### 报错1：`python3: command not found`

**原因**：系统没有安装 Python 3

**解决方法**：先安装 Python 3
```bash
sudo apt update
sudo apt install python3
```
安装完成后，重新运行 `bash install.sh`

---

### 报错2：`bash: install.sh: No such file or directory`

**原因**：当前目录不在仓库根目录，或者没有 `install.sh` 文件

**解决方法**：
1. 确认你在正确的目录：
```bash
ls
```
查看是否有 `install.sh` 文件

2. 如果没有，说明你不在仓库根目录，先进入仓库目录：
```bash
cd 你的仓库路径
```
然后重新运行 `bash install.sh`

---

### 报错3：`Permission denied (install.sh)`

**原因**：`install.sh` 没有执行权限

**解决方法**：给脚本添加执行权限
```bash
chmod +x install.sh
./install.sh
```
或者直接使用 `bash` 运行：
```bash
bash install.sh
```

---

### 报错4：`E: Unable to locate package python3-pip`

**原因**：apt 源没有更新，或者网络不通

**解决方法**：
```bash
sudo apt update
sudo apt install python3-pip
```
如果还是失败，检查网络连接或更换 apt 源。

---

### 报错5：`externally-managed-environment`

**原因**：Ubuntu 24.04+ 的系统保护机制

**解决方法**：脚本已经自动处理了这个错误，会自动加上 `--break-system-packages`。如果你手动安装，用以下命令：
```bash
pip3 install numpy matplotlib --break-system-packages
```

---

### 报错6：`pip: command not found`（安装后仍提示）

**原因**：pip 安装了但路径没有添加到环境变量

**解决方法**：
```bash
# 方法1：使用 python3 -m pip 代替 pip3
python3 -m pip install numpy matplotlib

# 方法2：重新安装 pip
sudo apt install --reinstall python3-pip

# 方法3：手动添加路径
export PATH=$PATH:~/.local/bin
```
然后重新运行 `bash install.sh`

---

### 报错7：运行代码时 `No module named 'numpy' / 'matplotlib'`

**原因**：VS Code 选错了 Python 解释器

**解决方法**：
1. 按 `Ctrl + Shift + P`
2. 输入 `Python: Select Interpreter`
3. 选择 `/usr/bin/python3`（Ubuntu 用户）或 `/home/xxx/...`（WSL 用户）
4. 不要选路径很长的（如 conda 或虚拟环境）

**验证是否选对**：在终端输入 `which python3`，显示的路径应该和你选择的解释器路径一致。

---

### 报错8：VS Code 右下角没有 Python 版本显示

**原因**：没有安装 Python 插件

**解决方法**：
1. 按 `Ctrl + Shift + X` 打开扩展面板
2. 搜索 `Python`
3. 安装作者为 **Microsoft** 的 Python 插件
4. 安装后重新加载 VS Code

---

### 报错9：Code Runner 运行报错

**原因**：Code Runner 插件使用了错误的 Python 路径

**解决方法**：本仓库的 `.vscode/settings.json` 已经配置好，确保该文件存在。如果还有问题，手动修改：
1. 按 `Ctrl + ,` 打开设置
2. 搜索 `code-runner.executorMap`
3. 找到 `python` 项，改为：
```json
"python": "python3 -u"
```

---

### 报错10：WSL 中无法连接网络/安装很慢

**原因**：网络问题或 apt/pip 源太慢

**解决方法**：

**解决安装慢**：使用国内镜像
```bash
pip3 install numpy matplotlib -i https://pypi.tuna.tsinghua.edu.cn/simple
```

**解决 WSL 网络不通**（常见于公司网络/代理）：
```bash
# 重启 WSL 网络
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "nameserver 8.8.4.4" >> /etc/resolv.conf'
```

---

### 报错11：`.vscode/settings.json` 出现黄色警告

**原因**：VS Code 在检查配置时无法解析 `${workspaceFolder}` 变量（这是正常的，不影响功能）

**解决方法**：**忽略这个警告**，它不影响使用。如果你想消除警告，可以删除 `python.defaultInterpreterPath` 这一行，改为：

```json
{
    "python.terminal.activateEnvironment": true,
    "python.terminal.activateEnvInCurrentTerminal": true,
    "code-runner.executorMap": {
        "python": "python3 -u"
    },
    "code-runner.clearPreviousOutput": true,
    "code-runner.showExecutionMessage": false
}
```

---

## 最终验证

在 VS Code 中新建一个 Python 文件，输入以下代码并运行：

```python
import sys
print("Python路径:", sys.executable)

import numpy
print("numpy版本:", numpy.__version__)

import matplotlib
print("matplotlib版本:", matplotlib.__version__)
```

正常输出版本号（例如 `numpy: 1.24.0`）即表示环境配置成功，可以开始写代码了！

---

## 还是不行？

请检查一下信息再查阅相关资料解决：
1. VS Code 右下角的 Python 版本显示
2. 终端中运行 `which python3` 的输出
3. 运行 `bash install.sh` 的完整输出
4. 运行代码时的完整报错信息