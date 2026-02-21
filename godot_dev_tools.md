# Godot AI 辅助开发验证工具集成方案

## 概述

解决AI在Godot游戏开发中的"幻觉"问题，通过引入验证和测试工具，确保AI生成的代码真正可运行。

---

## 工具清单

### 1. MCP (Model Context Protocol) - AI与Godot的桥梁 ✅ 已安装

**作用**: 让AI能够直接连接和操作Godot编辑器，获得真实的项目状态和错误反馈

**核心功能**:
- 读取项目状态：场景树结构、节点属性
- 执行操作：添加节点、修改场景、创建文件
- 智能调试：获取编辑器输出、捕获截图
- 形成"编写 → 运行 → 读取错误 → 修复"的闭环

**已安装**: `godot-mcp` (PyPI)
- 位置: `/home/pi/.openclaw/workspace/venv-godot-mcp/`
- 提供25+工具函数

**可用工具**:
| 类别 | 工具 |
|------|------|
| Godot | godot_get_version |
| 编辑器 | editor_launch |
| 项目 | project_list, project_run, project_stop, project_get_debug_output, project_export, project_setting_get/set |
| 场景 | scene_create, scene_list, scene_get_tree, scene_save, scene_instantiate |
| 节点 | node_add, node_delete, node_rename, node_reparent, node_set_property, node_get_properties |
| 脚本 | script_create, script_attach, script_detach, script_list |
| 信号 | signal_connect, signal_disconnect, signal_list_connections |
| 资源 | resource相关操作 |
| UI | ui相关操作 |
| 物理 | physics, collision相关操作 |

### 2. Godot Doctor - 场景验证插件

**作用**: 场景验证插件 保存场景时自动检查节点引用错误、资源丢失、属性值非法

**安装**: Godot 4.x AssetLibrary搜索 "godot-doctor"

**功能**:
- 节点路径验证
- 资源引用检查
- 属性值范围验证

### 3. GdUnit4 - 单元测试框架

**作用**: 为逻辑编写测试核心用例，确保代码逻辑正确

**安装**: Godot 4.x AssetLibrary搜索 "GdUnit4"

**测试覆盖**:
- 物理逻辑（弹球碰撞、弹射力度）
- 得分计算
- 游戏状态管理
- UI交互

---

## 验证工作流

```
┌─────────────────────────────────────────────────────────────┐
│                    AI 代码生成                               │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│              Godot Doctor 场景验证                          │
│         (检查节点引用、资源路径、属性值)                      │
└─────────────────────┬───────────────────────────────────────┘
                      │
           ┌──────────┴──────────┐
           │                      │
           ▼                      ▼
      验证通过                验证失败
           │                      │
           ▼                      ▼
┌─────────────────────┐  ┌─────────────────────┐
│   GdUnit4 单元测试  │  │  报告错误位置        │
│  (核心逻辑测试)      │  │  返回AI重新生成     │
└─────────────────────┬─┘ └─────────────────────┘
                      │
                      ▼
           ┌────────────────────────┐
           │    Godot 实际运行       │
           │  (Play/测试模式)        │
           └────────────────────────┘
                      │
                      ▼
           ┌────────────────────────┐
           │   获取错误日志/截图    │
           │   AI分析并修复         │
           └────────────────────────┘
```

---

## PI-PinBall 集成计划

### 阶段1: MCP服务器配置 (当前)
- [x] 安装godot-mcp到虚拟环境
- [x] 创建启动脚本
- [ ] 配置OpenClaw MCP客户端连接

### 阶段2: Godot安装 (需要主机)
- [ ] 在开发机器上安装Godot 4.5
- [ ] 配置GODOT_PATH环境变量
- [ ] 测试MCP连接

### 阶段3: 测试框架 (待定)
- [ ] 安装GdUnit4插件
- [ ] 编写核心逻辑测试用例
- [ ] 集成到CI/CD

---

## MCP服务器启动

```bash
# 方式1: 使用脚本
./scripts/run_godot_mcp.sh

# 方式2: 手动
source venv-godot-mcp/bin/activate
export GODOT_PATH=/path/to/godot
python -m godot_mcp.server
```

---

## 替代方案: OpenClaw内置方案

如果MCP配置复杂，可使用OpenClaw现有工具:

1. **browser工具**: 控制Godot编辑器获取状态
2. **exec工具**: 运行godot命令行进行验证
3. **截图功能**: 捕获游戏画面确认运行正常

---

## 相关文件

- `/workspace/pi-pin-ball/` - PI-PinBall主项目
- `/workspace/game/pin-ball/` - 旧版Pinball维护项目
- `/workspace/venv-godot-mcp/` - godot-mcp虚拟环境

---

*最后更新: 2026-02-21*
