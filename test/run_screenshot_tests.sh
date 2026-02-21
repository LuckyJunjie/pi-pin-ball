#!/bin/bash
# 截图测试运行器
# 用法: ./run_screenshot_tests.sh [--update-baseline]

PROJECT_DIR="/home/pi/.openclaw/workspace/pi-pin-ball"
GODOT_CMD="godot"

# 解析参数
UPDATE_BASELINE=false
if [ "$1" == "--update-baseline" ]; then
    UPDATE_BASELINE=true
fi

cd "$PROJECT_DIR"

echo "========================================="
echo "PI-PinBall 截图测试"
echo "========================================="

# 创建测试标记文件
if [ "$UPDATE_BASELINE" = true ]; then
    echo "更新基准截图模式"
    echo "update_mode=true" > test/screenshot/.test_mode
else
    echo "对比测试模式"
    echo "update_mode=false" > test/screenshot/.test_mode
fi

# 运行Godot测试
if command -v godot &> /dev/null; then
    godot --headless --path . -s test/run_screenshot_tests.gd
else
    echo "Godot未安装，请先安装Godot 4.5+"
    echo "或配置GODOT_PATH环境变量"
    exit 1
fi

echo ""
echo "========================================="
echo "测试完成"
echo "========================================="
