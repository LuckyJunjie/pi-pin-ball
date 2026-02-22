#!/usr/bin/env bash
# run_tests_with_logging.sh - 运行测试并输出详细日志

set -e

echo "=========================================="
echo "PI-PinBall 测试套件 (控制台模式)"
echo "=========================================="

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo -e "${BLUE}项目路径: $PROJECT_DIR${NC}"
echo ""

# 检查Godot
if ! command -v godot &> /dev/null; then
    echo -e "${RED}错误: Godot未安装${NC}"
    exit 1
fi

# 测试函数
run_test() {
    local test_name=$1
    local test_file=$2
    
    echo -e "${YELLOW}[测试] $test_name${NC}"
    echo "----------------------------------------"
    
    if godot --headless --path . -s "$test_file" 2>&1; then
        echo -e "${GREEN}✅ $test_name 通过${NC}"
    else
        echo -e "${RED}❌ $test_name 失败${NC}"
    fi
    echo ""
}

# 运行各个测试
echo -e "${BLUE}1. 单元测试${NC}"
echo "=========================================="
godot --headless --path . -s test/run_tests.gd 2>&1 | head -100

echo ""
echo -e "${BLUE}2. 场景切换测试${NC}"
echo "=========================================="
if [ -f "test/integration/test_scene_transition.gd" ]; then
    godot --headless --path . -s test/integration/test_scene_transition.gd 2>&1 | head -50
else
    echo -e "${YELLOW}⚠ 场景切换测试文件不存在${NC}"
fi

echo ""
echo -e "${BLUE}3. 截图测试${NC}"
echo "=========================================="
if [ -f "./test/run_screenshot_tests.sh" ]; then
    chmod +x ./test/run_screenshot_tests.sh
    ./test/run_screenshot_tests.sh 2>&1 | head -30
else
    echo -e "${YELLOW}⚠ 截图测试脚本不存在${NC}"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}测试完成${NC}"
echo "=========================================="
