#!/usr/bin/env bash
# run_console_tests.sh - 运行控制台日志测试

set -e

echo "=========================================="
echo "PI-PinBall 控制台日志测试"
echo "=========================================="

cd /home/pi/.openclaw/workspace/pi-pin-ball

# 颜色
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 运行测试并捕获
echo -e "${YELLOW}运行测试...${NC}"
godot --headless --path . -s test/run_tests.gd 2>&1 | tee test_output.log

# 分析结果
echo ""
echo "=========================================="
echo "测试结果分析"
echo "=========================================="

PASSED=$(grep -c "✅" test_output.log 2>/dev/null || echo "0")
FAILED=$(grep -c "❌" test_output.log 2>/dev/null || echo "0")
ERRORS=$(grep -c "\[ERROR\]" test_output.log 2>/dev/null || echo "0")
TESTS=$(grep -c "\[TEST\]" test_output.log 2>/dev/null || echo "0")

echo "测试总数: $TESTS"
echo -e "通过: ${GREEN}$PASSED${NC}"
echo -e "失败: ${RED}$FAILED${NC}"
echo -e "错误: ${RED}$ERRORS${NC}"

# 显示错误
if [ "$ERRORS" -gt 0 ] || [ "$FAILED" -gt 0 ]; then
    echo ""
    echo "错误详情:"
    grep -E "\[ERROR\]|❌" test_output.log | head -20
    exit 1
else
    echo ""
    echo -e "${GREEN}✅ 所有测试通过!${NC}"
    exit 0
fi
