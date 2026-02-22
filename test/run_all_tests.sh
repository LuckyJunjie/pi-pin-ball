#!/usr/bin/env bash
# PI-PinBall 测试运行脚本
# 运行所有测试并生成报告

set -e

echo "========================================"
echo "PI-PinBall 测试套件"
echo "========================================"

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 项目根目录
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

echo "项目路径: $PROJECT_DIR"
echo ""

# 检查Godot是否可用
if ! command -v godot &> /dev/null; then
    echo -e "${RED}错误: Godot未安装或不在PATH中${NC}"
    exit 1
fi

# 运行单元测试
echo -e "${YELLOW}[1/3] 运行单元测试...${NC}"
if godot --headless --path . -s test/run_tests.gd 2>&1; then
    echo -e "${GREEN}✓ 单元测试通过${NC}"
else
    echo -e "${RED}✗ 单元测试失败${NC}"
fi
echo ""

# 运行截图测试
echo -e "${YELLOW}[2/3] 运行截图测试...${NC}"
if [ -f "./test/run_screenshot_tests.sh" ]; then
    chmod +x ./test/run_screenshot_tests.sh
    if ./test/run_screenshot_tests.sh 2>&1; then
        echo -e "${GREEN}✓ 截图测试通过${NC}"
    else
        echo -e "${RED}✗ 截图测试失败${NC}"
    fi
else
    echo -e "${YELLOW}⚠ 截图测试脚本不存在，跳过${NC}"
fi
echo ""

# 生成测试报告
echo -e "${YELLOW}[3/3] 生成测试报告...${NC}"
REPORT_FILE="test_results_$(date +%Y%m%d_%H%M%S).txt"
{
    echo "PI-PinBall 测试报告"
    echo "==================="
    echo "时间: $(date)"
    echo ""
    echo "测试完成"
} > "$REPORT_FILE"
echo -e "${GREEN}报告已保存: $REPORT_FILE${NC}"

echo ""
echo "========================================"
echo "测试完成"
echo "========================================"
