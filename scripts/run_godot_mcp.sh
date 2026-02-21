#!/bin/bash
# Godot MCP Server Launcher
# 用法: ./run_godot_mcp.sh [godot_path]

# 激活虚拟环境
source /home/pi/.openclaw/workspace/venv-godot-mcp/bin/activate

# 设置Godot路径（如果提供）
if [ -n "$1" ]; then
    export GODOT_PATH="$1"
    echo "Using Godot from: $GODOT_PATH"
fi

# 运行MCP服务器
echo "Starting Godot MCP Server..."
python -m godot_mcp.server
