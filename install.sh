#!/bin/bash
# 一键安装依赖脚本
# 支持：Ubuntu 18.04/20.04/22.04/24.04、WSL Ubuntu、macOS
# 从 requirements.txt 读取依赖列表进行安装

set -e  # 遇到错误继续执行，不退出

echo "=========================================="
echo "  Python 环境自动配置脚本"
echo "=========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ========================================
# 检测操作系统
# ========================================
echo ""
echo "[1/6] 检测操作系统..."

OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    echo "检测到系统: Linux"
    
    # 检测是否在 WSL 中
    if grep -qi microsoft /proc/version 2>/dev/null; then
        IS_WSL=true
        echo "检测到环境: WSL Ubuntu"
    else
        IS_WSL=false
        echo "检测到环境: Ubuntu"
    fi
    
    # 检测 Ubuntu 版本
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        UBUNTU_VERSION=$VERSION_ID
        echo "Ubuntu 版本: $UBUNTU_VERSION"
    else
        UBUNTU_VERSION="unknown"
    fi
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    echo "检测到系统: macOS"
else
    echo -e "${RED}错误: 不支持的操作系统 ($OSTYPE)${NC}"
    echo "目前只支持 Ubuntu / WSL Ubuntu / macOS"
    exit 1
fi

# ========================================
# 检查 requirements.txt
# ========================================
echo ""
echo "[2/6] 检查依赖列表文件..."

if [ ! -f "requirements.txt" ]; then
    echo -e "${RED}错误: 找不到 requirements.txt 文件${NC}"
    echo "请确保你在仓库根目录下运行此脚本"
    echo "当前目录: $(pwd)"
    echo ""
    echo "解决方法："
    echo "1. 确认你是否在仓库根目录（用 ls 查看是否有 requirements.txt）"
    echo "2. 如果不在，请 cd 到正确的目录"
    exit 1
fi

echo -e "${GREEN}✓ 找到 requirements.txt${NC}"
echo ""
echo "将要安装以下依赖："
echo -e "${BLUE}----------------------------------------${NC}"
cat requirements.txt
echo -e "${BLUE}----------------------------------------${NC}"

# ========================================
# 确保 python3 可用
# ========================================
echo ""
echo "[3/6] 检查 Python 3..."

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}错误: 未找到 python3${NC}"
    if [ "$OS" = "macos" ]; then
        echo "请先安装 Python 3:"
        echo "  方法1: brew install python3"
        echo "  方法2: 从 https://www.python.org/downloads/ 下载安装"
    else
        echo "请先安装 Python 3: sudo apt update && sudo apt install python3"
    fi
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | grep -oP '(?<=Python )\d+\.\d+' || python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1-2)
echo -e "${GREEN}✓ Python 版本: $PYTHON_VERSION${NC}"

# ========================================
# 确保 pip 已安装
# ========================================
echo ""
echo "[4/6] 检查 pip3..."

if ! command -v pip3 &> /dev/null; then
    echo "未找到 pip3，正在安装..."
    if [ "$OS" = "macos" ]; then
        # macOS 安装 pip
        python3 -m ensurepip --upgrade 2>/dev/null || {
            echo -e "${YELLOW}提示: pip 安装失败，请手动安装:${NC}"
            echo "  curl https://bootstrap.pypa.io/get-pip.py | python3"
            exit 1
        }
    else
        # Linux 安装 pip
        sudo apt update
        sudo apt install -y python3-pip
    fi
    echo -e "${GREEN}✓ pip3 安装完成${NC}"
else
    echo -e "${GREEN}✓ pip3 已安装${NC}"
fi

# ========================================
# 升级 pip（可选，但推荐）
# ========================================
echo ""
echo "[5/6] 升级 pip..."

if [ "$OS" = "macos" ]; then
    # macOS 不需要 --break-system-packages
    pip3 install --upgrade pip 2>/dev/null || true
else
    # Linux：根据 Ubuntu 版本选择不同的升级策略
    if [ "$UBUNTU_VERSION" = "18.04" ]; then
        pip3 install --user --upgrade pip 2>/dev/null || true
    else
        pip3 install --upgrade pip --break-system-packages 2>/dev/null || \
        pip3 install --upgrade pip 2>/dev/null || true
    fi
fi
echo -e "${GREEN}✓ pip 已是最新${NC}"

# ========================================
# 安装依赖（从 requirements.txt）
# ========================================
echo ""
echo "[6/6] 安装依赖库..."

# 构建安装命令
INSTALL_BASE="pip3 install -r requirements.txt"

# 根据操作系统和版本选择参数
if [ "$OS" = "macos" ]; then
    # macOS 不需要特殊参数
    INSTALL_CMD="$INSTALL_BASE"
    USER_CMD="pip3 install --user -r requirements.txt"
else
    # Linux：根据 Ubuntu 版本选择
    if [ "$UBUNTU_VERSION" = "24.04" ] || [ "$UBUNTU_VERSION" = "22.04" ]; then
        # 22.04 和 24.04 需要 --break-system-packages
        INSTALL_CMD="$INSTALL_BASE --break-system-packages"
        USER_CMD="pip3 install --user -r requirements.txt --break-system-packages"
    elif [ "$UBUNTU_VERSION" = "18.04" ] || [ "$UBUNTU_VERSION" = "20.04" ]; then
        # 18.04 和 20.04 不需要特殊参数
        INSTALL_CMD="$INSTALL_BASE"
        USER_CMD="pip3 install --user -r requirements.txt"
    else
        # 未知版本，尝试用 --break-system-packages（新版本）
        INSTALL_CMD="$INSTALL_BASE --break-system-packages"
        USER_CMD="pip3 install --user -r requirements.txt --break-system-packages"
    fi
fi

# 尝试安装
echo "执行安装命令..."
echo ""

if $INSTALL_CMD 2>/dev/null; then
    echo ""
    echo -e "${GREEN}✓ 依赖库安装成功${NC}"
elif $USER_CMD 2>/dev/null; then
    echo ""
    echo -e "${GREEN}✓ 依赖库安装成功（--user 模式）${NC}"
else
    # 备用方案：逐一手动安装
    echo ""
    echo "批量安装失败，尝试逐个安装..."
    SUCCESS=1
    while IFS= read -r package; do
        # 跳过空行和注释
        if [[ -z "$package" || "$package" == \#* ]]; then
            continue
        fi
        echo "安装: $package"
        
        if [ "$OS" = "macos" ]; then
            if ! pip3 install "$package" 2>/dev/null; then
                pip3 install --user "$package" 2>/dev/null || SUCCESS=0
            fi
        else
            if [ "$UBUNTU_VERSION" = "24.04" ] || [ "$UBUNTU_VERSION" = "22.04" ]; then
                if ! pip3 install "$package" --break-system-packages 2>/dev/null; then
                    pip3 install --user "$package" --break-system-packages 2>/dev/null || SUCCESS=0
                fi
            else
                if ! pip3 install "$package" 2>/dev/null; then
                    pip3 install --user "$package" 2>/dev/null || SUCCESS=0
                fi
            fi
        fi
    done < requirements.txt
    
    if [ $SUCCESS -eq 0 ]; then
        echo ""
        echo -e "${YELLOW}提示: 部分包安装失败，尝试用系统包管理器安装...${NC}"
        if [ "$OS" = "macos" ]; then
            echo "请手动安装缺失的包: pip3 install <包名>"
        else
            # 备用方案：用 apt 安装
            sudo apt update
            while IFS= read -r package; do
                if [[ -z "$package" || "$package" == \#* ]]; then
                    continue
                fi
                echo "尝试用 apt 安装: python3-$package"
                sudo apt install -y "python3-$package" 2>/dev/null || true
            done < requirements.txt
        fi
        echo -e "${GREEN}✓ 安装完成${NC}"
    else
        echo -e "${GREEN}✓ 所有依赖安装成功${NC}"
    fi
fi

# ========================================
# 验证安装
# ========================================
echo ""
echo "=========================================="
echo "  验证安装"
echo "=========================================="

# 生成验证命令（动态检查 requirements.txt 中的所有包）
VERIFY_CMD="import sys; print('Python 路径:', sys.executable); print('')"

while IFS= read -r package; do
    # 跳过空行和注释
    if [[ -z "$package" || "$package" == \#* ]]; then
        continue
    fi
    # 处理可能的包名中的版本号（如 numpy>=1.0 -> numpy）
    pkg_name=$(echo "$package" | cut -d'=' -f1 | cut -d'>' -f1 | cut -d'<' -f1 | tr -d ' ')
    VERIFY_CMD="$VERIFY_CMD
try:
    import $pkg_name
    print('✓ $pkg_name 已安装')
except ImportError:
    print('✗ $pkg_name: 未安装')
    sys.exit(1)
"
done < requirements.txt

python3 -c "$VERIFY_CMD"

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo -e "${GREEN}  ✓ 环境配置成功！可以开始写代码了${NC}"
    echo "=========================================="
    echo ""
    echo "提示：以后老师新增了依赖库，只需："
    echo "  1. git pull"
    echo "  2. bash install.sh"
    echo ""
else
    echo ""
    echo "=========================================="
    echo -e "${RED}  ✗ 部分依赖安装失败${NC}"
    echo "=========================================="
    echo ""
    echo "请检查上面的输出，找到未安装的包"
    echo "然后将报错信息截图发给老师"
    exit 1
fi