#!/bin/bash
# 一键安装依赖脚本
# 适用于：Ubuntu 18.04/20.04/22.04/24.04，以及 Windows WSL Ubuntu

set -e  # 遇到错误继续执行，不退出

echo "=========================================="
echo "  Python 环境自动配置脚本"
echo "=========================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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
    echo "Ubuntu 版本: 未知"
fi
echo ""

# ========================================
# 第一步：确保 python3 可用
# ========================================
echo "[1/5] 检查 Python 3..."

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}错误: 未找到 python3${NC}"
    echo "请先安装 Python 3: sudo apt update && sudo apt install python3"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | grep -oP '(?<=Python )\d+\.\d+')
echo -e "${GREEN}✓ Python 版本: $PYTHON_VERSION${NC}"

# ========================================
# 第二步：确保 pip 已安装
# ========================================
echo ""
echo "[2/5] 检查 pip3..."

if ! command -v pip3 &> /dev/null; then
    echo "未找到 pip3，正在安装..."
    sudo apt update
    sudo apt install -y python3-pip
    echo -e "${GREEN}✓ pip3 安装完成${NC}"
else
    echo -e "${GREEN}✓ pip3 已安装${NC}"
fi

# ========================================
# 第三步：升级 pip（可选，但推荐）
# ========================================
echo ""
echo "[3/5] 升级 pip..."

# 根据 Ubuntu 版本选择不同的升级策略
if [ "$UBUNTU_VERSION" = "18.04" ]; then
    # 18.04 的 pip 版本较老，用 --user 方式升级
    pip3 install --user --upgrade pip --break-system-packages 2>/dev/null || \
    pip3 install --user --upgrade pip 2>/dev/null || true
else
    pip3 install --upgrade pip --break-system-packages 2>/dev/null || \
    pip3 install --upgrade pip 2>/dev/null || true
fi
echo -e "${GREEN}✓ pip 已是最新${NC}"

# ========================================
# 第四步：安装 numpy 和 matplotlib
# ========================================
echo ""
echo "[4/5] 安装 numpy 和 matplotlib..."

# 构建安装命令（自动处理不同版本）
INSTALL_CMD="pip3 install"

# 根据 Ubuntu 版本选择参数
if [ "$UBUNTU_VERSION" = "24.04" ] || [ "$UBUNTU_VERSION" = "22.04" ]; then
    # 22.04 和 24.04 需要 --break-system-packages
    INSTALL_CMD="$INSTALL_CMD --break-system-packages"
fi

# 尝试安装（如果失败，尝试 --user 模式）
if $INSTALL_CMD numpy matplotlib 2>/dev/null; then
    echo -e "${GREEN}✓ numpy 和 matplotlib 安装成功${NC}"
elif $INSTALL_CMD --user numpy matplotlib 2>/dev/null; then
    echo -e "${GREEN}✓ numpy 和 matplotlib 安装成功（--user 模式）${NC}"
else
    # 最后的备用方案：用 apt 安装
    echo "pip 安装失败，尝试用 apt 安装..."
    sudo apt update
    sudo apt install -y python3-numpy python3-matplotlib
    echo -e "${GREEN}✓ 通过 apt 安装完成${NC}"
fi

# ========================================
# 第五步：验证安装
# ========================================
echo ""
echo "[5/5] 验证安装..."

python3 -c "
import sys
print('Python 路径:', sys.executable)
print('')

try:
    import numpy
    print('✓ numpy 版本:', numpy.__version__)
except ImportError:
    print('✗ numpy: 未安装')
    sys.exit(1)

try:
    import matplotlib
    print('✓ matplotlib 版本:', matplotlib.__version__)
except ImportError:
    print('✗ matplotlib: 未安装')
    sys.exit(1)
"

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo -e "${GREEN}  ✓ 环境配置成功！可以开始写代码了${NC}"
    echo "=========================================="
else
    echo ""
    echo "=========================================="
    echo -e "${RED}  ✗ 安装失败，请将报错信息截图发给老师${NC}"
    echo "=========================================="
    exit 1
fi