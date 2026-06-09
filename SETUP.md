# 环境配置指南

## 一句话搞定

在 VS Code 中按 `` Ctrl + ` `` 打开终端，输入以下命令：

```bash
bash install.sh
```

脚本会自动完成所有配置，看到 `✓ 环境配置成功！` 即表示完成。

**支持的系统：** Ubuntu 18.04/20.04/22.04/24.04、WSL Ubuntu、macOS

---

## 目录
- [如何正确打开项目](#如何正确打开项目)
- [可能遇到的报错及解决方法](#可能遇到的报错及解决方法)
  - [报错1：python3: command not found](#报错1python3-command-not-found)
  - [报错2：bash: install.sh: No such file or directory](#报错2bash-installsh-no-such-file-or-directory)
  - [报错3：Permission denied](#报错3permission-denied)
  - [报错4：找不到 requirements.txt](#报错4找不到-requirementstxt)
  - [报错5：E: Unable to locate package python3-pip](#报错5e-unable-to-locate-package-python3-pip)
  - [报错6：externally-managed-environment](#报错6externally-managed-environment)
  - [报错7：pip: command not found（安装后仍提示）](#报错7pip-command-not-found安装后仍提示)
  - [报错8：运行代码时 No module named 'xxx'](#报错8运行代码时-no-module-named-xxx)
  - [报错9：VS Code 右下角没有 Python 版本显示](#报错9vs-code-右下角没有-python-版本显示)
  - [报错10：Code Runner 运行报错](#报错10code-runner-运行报错)
  - [报错11：WSL 中无法连接网络/安装很慢](#报错11wsl-中无法连接网络安装很慢)
  - [报错12：macOS 报错 xcrun: error](#报错12macos-报错-xcrun-error)
  - [报错13：.vscode/settings.json 出现黄色警告](#报错13vscodesettingsjson-出现黄色警告)
- [以后如何更新依赖](#以后如何更新依赖)
- [最终验证](#最终验证)
- [还是不行？](#还是不行)

---

## 如何正确打开项目

**重要：** 请确保以**文件夹**方式打开项目，而不是直接打开单个 `.py` 文件，否则 `.vscode` 配置不会自动加载。

### Ubuntu 用户：
1. 打开 VS Code
2. 点击 `文件` → `打开文件夹`
3. 选择你 `git clone` 下来的仓库文件夹

### WSL 用户：
1. 先确认连接 WSL：按 `F1` → `WSL: Connect to WSL`（左下角会显示 `WSL: Ubuntu`）
2. 点击 `文件` → `打开文件夹`
3. 在左侧找到 Linux 目录下的仓库文件夹（路径如 `/home/你的用户名/仓库名`）

### macOS 用户：
1. 打开 VS Code
2. 点击 `文件` → `打开文件夹`
3. 选择你 `git clone` 下来的仓库文件夹

打开后，VS Code 会自动加载本项目的配置，右下角会提示文件夹中的设置已应用。

---

## 可能遇到的报错及解决方法

### 报错1：`python3: command not found`

**原因**：系统没有安装 Python 3

**解决方法**：

- **Ubuntu / WSL：**
```bash
sudo apt update
sudo apt install python3
```

- **macOS：**
```bash
# 方法1：使用 Homebrew
brew install python3

# 方法2：从官网下载
# 访问 https://www.python.org/downloads/
```

安装完成后，重新运行 `bash install.sh`

---

### 报错2：`bash: install.sh: No such file or directory`

**原因**：当前目录不在仓库根目录

**解决方法**：
1. 确认你在正确的目录：
```bash
ls
```
查看是否有 `install.sh` 文件

2. 如果没有，先进入仓库目录：
```bash
cd 你的仓库路径
```
然后重新运行 `bash install.sh`

---

### 报错3：`Permission denied`

**原因**：`install.sh` 没有执行权限

**解决方法**：
```bash
chmod +x install.sh
bash install.sh
```

---

### 报错4：`找不到 requirements.txt`

**原因**：脚本找不到依赖列表文件

**解决方法**：
1. 确认你在仓库根目录：
```bash
ls
```
应该能看到 `requirements.txt` 和 `install.sh`

2. 如果文件确实不存在，联系老师确认仓库是否正确克隆

---

### 报错5：`E: Unable to locate package python3-pip`

**原因**：apt 源没有更新

**解决方法**：
```bash
sudo apt update
sudo apt install python3-pip
```
如果还是失败，检查网络连接。

---

### 报错6：`externally-managed-environment`

**原因**：Ubuntu 24.04+ 的系统保护机制

**解决方法**：脚本已经自动处理了这个错误。如果你手动安装，用以下命令：
```bash
pip3 install numpy matplotlib --break-system-packages
```

---

### 报错7：`pip: command not found`（安装后仍提示）

**原因**：pip 安装了但路径没有添加到环境变量

**解决方法**：

- **Ubuntu / WSL：**
```bash
# 方法1：使用 python3 -m pip
python3 -m pip install -r requirements.txt

# 方法2：重新安装 pip
sudo apt install --reinstall python3-pip

# 方法3：手动添加路径
export PATH=$PATH:~/.local/bin
```

- **macOS：**
```bash
python3 -m pip install -r requirements.txt
```

---

### 报错8：运行代码时 `No module named 'xxx'`

**原因**：VS Code 选错了 Python 解释器

**解决方法**：
1. 按 `Ctrl + Shift + P`
2. 输入 `Python: Select Interpreter`
3. 选择正确的解释器：
   - **Ubuntu/WSL：** 选择 `/usr/bin/python3`
   - **macOS：** 选择 `/usr/local/bin/python3` 或 `/opt/homebrew/bin/python3`
4. 不要选择路径很长的（如 conda 或虚拟环境）

**验证是否选对：** 在终端输入 `which python3`，显示的路径应该和你选择的解释器路径一致。

---

### 报错9：VS Code 右下角没有 Python 版本显示

**原因**：没有安装 Python 插件

**解决方法**：
1. 按 `Ctrl + Shift + X` 打开扩展面板
2. 搜索 `Python`
3. 安装作者为 **Microsoft** 的 Python 插件
4. 安装后重新加载 VS Code

---

### 报错10：Code Runner 运行报错

**原因**：Code Runner 插件使用了错误的 Python 路径

**解决方法**：本仓库的 `.vscode/settings.json` 已经配置好，确保：
1. 以**文件夹**方式打开项目（参考上面的[如何正确打开项目](#如何正确打开项目)）
2. 如果还有问题，手动修改：按 `Ctrl + ,` → 搜索 `code-runner.executorMap` → 将 `python` 改为 `python3 -u`

---

### 报错11：WSL 中无法连接网络/安装很慢

**原因**：网络问题或 apt/pip 源太慢

**解决方法**：

**解决安装慢**：使用国内镜像
```bash
pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
```

**解决 WSL 网络不通**（常见于公司网络/代理）：
```bash
# 重启 WSL 网络
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "nameserver 8.8.4.4" >> /etc/resolv.conf'
```

---

### 报错12：macOS 报错 `xcrun: error`

**原因**：Xcode Command Line Tools 未安装

**解决方法**：
```bash
xcode-select --install
```
按照提示完成安装后，重新运行 `bash install.sh`

---

### 报错13：`.vscode/settings.json` 出现黄色警告

**原因**：VS Code 在检查配置时无法解析变量（**不影响功能**）

**解决方法**：**忽略这个警告**，它不影响使用。如果你想消除警告，可以删除 `python.defaultInterpreterPath` 这一行。

---

## 以后如何更新依赖

当老师新增了依赖库（例如增加了 `pandas`、`scipy` 等），你只需要：

```bash
git pull
bash install.sh
```

脚本会自动安装所有新增的依赖。

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

请将以下信息截图发给老师：
1. VS Code 右下角的 Python 版本显示
2. 终端中运行 `which python3` 的输出
3. 运行 `bash install.sh` 的完整输出
4. 运行代码时的完整报错信息
5. 你的操作系统和版本（Ubuntu/WSL/macOS）