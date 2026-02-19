# Flutter I/O Pinball 游戏机制分析

**分析时间:** 2026-02-19  
**分析人员:** Vanguard001  
**目标:** 复刻到Godot 4.5

---

## 1. 游戏引擎架构

### 1.1 引擎选择

| 组件 | Flutter原版 | Godot目标 |
|------|-------------|----------|
| 游戏引擎 | Flame | Godot Engine |
| 物理引擎 | Forge2D (Box2D) | Godot Physics 2D |
| 状态管理 | Flame Bloc | Godot Signals/State Machine |
| UI框架 | Flutter Widgets | Godot UI Controls |

### 1.2 物理配置

```dart
// Flutter原版
gravity: Vector2(0, 30)

// Godot目标
Project Settings -> Physics -> 2D -> Gravity: 980 (y轴)
```

---

## 2. 核心组件架构

### 2.1 游戏主循环

```
PinballGame (Forge2DGame)
├── BallSpawningBehavior (球生成)
├── CharacterSelectionBehavior (角色选择)
├── CameraFocusingBehavior (相机控制)
└── ZCanvasComponent (游戏画布)
    ├── BoardBackground (背景)
    ├── Boundaries (边界)
    ├── Backbox (得分显示)
    ├── GoogleGallery (区域)
    ├── Multipliers (倍率)
    ├── Multiballs (多球)
    ├── SkillShot (技能球)
    ├── AndroidAcres (区域)
    ├── DinoDesert (区域)
    ├── FlutterForest (区域)
    ├── SparkyScorch (区域)
    ├── Drain (漏球口)
    ├── BottomGroup (底部组)
    └── Launcher (发射器)
```

### 2.2 组件映射表

| Flutter组件 | Godot等价物 | 说明 |
|------------|-------------|------|
| `Ball` | Ball.tscn | RigidBody2D |
| `Flipper` | Flipper.tscn | StaticBody2D/Area2D |
| `Plunger` | Launcher.tscn | StaticBody2D + AnimationPlayer |
| `LaunchRamp` | LaunchRamp.tscn | StaticBody2D |
| `Drain` | Drain.tscn | Area2D |
| `ScoringContactBehavior` | ScoringArea.gd | Area2D + Script |

---

## 3. 核心游戏机制

### 3.1 球生成系统

**Flutter实现:**
```dart
class BallSpawningBehavior extends Component {
  void onNewGameState(GameState state) {
    final plunger = gameRef.descendants().whereType<Plunger>().single;
    final ball = Ball(
      assetPath: characterTheme.ball.keyName,
      initialPosition: Vector2(
        plunger.body.position.x,
        plunger.body.position.y - Ball.size.y,
      ),
      layer: Layer.launcher,
      zIndex: ZIndexes.ballOnLaunchRamp,
    );
    canvas.add(ball);
  }
}
```

**Godot实现:**
```gdscript
# BallSpawner.gd
extends Node

@export var ball_scene: PackedScene
@export var spawn_position: Vector2 = Vector2(720, 450)

func spawn_ball() -> void:
    var ball = ball_scene.instantiate()
    ball.position = spawn_position
    ball.z_index = 10
    get_parent().add_child(ball)
```

### 3.2 发射器机制

**关键参数:**
| 参数 | Flutter值 | Godot值 |
|------|----------|----------|
| 重力 | 30 | 980 |
| 发射力 | 500-1000 | 需调整 |
| 发射位置 | (41, 43.7) | 需转换坐标系 |

### 3.3 得分系统

**Flutter实现:**
```dart
class ScoringContactBehavior extends ContactBehavior {
  void beginContact(Object other, Contact contact) {
    if (other is Ball) {
      parent.add(
        ScoringBehavior(
          points: _points,  // 例如: Points.oneMillion
          position: other.body.position,
        ),
      );
    }
  }
}

class ScoringBehavior extends Component {
  void onLoad() async {
    bloc.add(Scored(points: _points.value));
    // 显示分数动画
  }
}
```

**Godot实现:**
```gdscript
# ScoringArea.gd
extends Area2D

@export var points: int = 1000000

func _on_body_entered(body: Node2D) -> void:
    if body is Ball:
        GameManager.add_score(points)
        show_score_popup(body.position, points)
```

---

## 4. 游戏区域设计

### 4.1 区域列表

| 区域 | 描述 | 得分 |
|------|------|------|
| **GoogleGallery** | Google产品展示 | ? |
| **Multipliers** | 倍率区域 | x2, x3, x5, x7, x10 |
| **Multiballs** | 多球奖励 | 额外球 |
| **SkillShot** | 技能球 | 1,000,000分 |
| **AndroidAcres** | Android主题 | ? |
| **DinoDesert** | 恐龙主题 | ? |
| **FlutterForest** | Flutter主题 | ? |
| **SparkyScorch** | 火花主题 | ? |
| **Drain** | 漏球口 | 游戏结束 |

### 4.2 倍率系统

| 击中次数 | 倍率 | 总分 |
|----------|------|------|
| 5次 | x2 | 基础分 x 2 |
| 10次 | x3 | 基础分 x 3 |
| 15次 | x5 | 基础分 x 5 |
| 20次 | x7 | 基础分 x 7 |
| 25次 | x10 | 基础分 x 10 |

---

## 5. 输入控制

### 5.1 控制映射

| 输入 | Flutter | Godot |
|------|----------|--------|
| 左挡板 | 左箭头/A | `ui_left` / `ui_accept` |
| 右挡板 | 右箭头/D | `ui_right` |
| 发射球 | 空格/Space | `ui_accept` |
| 暂停 | Esc | `ui_cancel` |

### 5.2 挡板控制代码

**Flutter:**
```dart
class Flapper extends Component with SingleContactEmitter {
  void onTapDown(TapDownEvent event) {
    // 旋转挡板
    body.angularVelocity = 20;
  }
  
  void onTapUp(TapUpEvent event) {
    // 复位挡板
    body.angularVelocity = -20;
  }
}
```

**Godot:**
```gdscript
# Flipper.gd
extends StaticBody2D

@export var max_rotation: float = 45.0
@export var rotation_speed: float = 20.0

func _physics_process(delta: float) -> void:
    if Input.is_action_pressed("ui_accept"):
        rotation_degrees = move_toward(rotation_degrees, max_rotation, rotation_speed * delta)
    else:
        rotation_degrees = move_toward(rotation_degrees, 0, rotation_speed * delta)
```

---

## 6. 状态管理

### 6.1 游戏状态

```dart
enum GameStatus {
  waiting,    // 等待开始
  playing,    // 游戏中
  gameOver,   // 游戏结束
}

class GameState {
  final GameStatus status;
  final int rounds;      // 剩余球数
  final int score;       // 当前得分
  final int multiplier;   // 当前倍率
}
```

### 6.2 Godot状态机

```gdscript
# GameManager.gd
extends Node

enum GameState { WAITING, PLAYING, GAME_OVER }

var current_state: GameState = GameState.WAITING
var rounds: int = 3
var score: int = 0
var multiplier: int = 1

signal game_started()
signal game_over()
signal score_changed(points: int)
signal multiplier_changed(mult: int)
```

---

## 7. 资源映射

### 7.1 美术资源

| 资源类型 | Flutter路径 | Godot路径 |
|---------|-------------|----------|
| 背景 | `assets/images/` | `assets/background/` |
| 角色 | `assets/images/characters/` | `assets/characters/` |
| UI | Flutter Widgets | `scenes/ui/` |

### 7.2 音效资源

| 音效 | Flutter | Godot |
|------|----------|--------|
| 挡板点击 | `flipper_click.wav` | `audio/sfx/flipper.wav` |
| 碰撞 | `obstacle_hit.wav` | `audio/sfx/hit.wav` |
| 发射 | `ball_launch.wav` | `audio/sfx/launch.wav` |
| 得分 | `score.wav` | `audio/sfx/score.wav` |

---

## 8. 实现优先级

### 8.1 P0 - 核心机制 (必须实现)

| 优先级 | 功能 | 预估时间 |
|--------|------|----------|
| **P0-1** | 物理引擎 (Ball, Flipper, Wall) | 3天 |
| **P0-2** | 发射器 (Launcher, Plunger) | 1天 |
| **P0-3** | 得分系统 (碰撞检测, 显示) | 1天 |
| **P0-4** | 游戏循环 (开始, 结束, 漏球) | 2小时 |
| **P0-5** | 挡板控制 | 4小时 |

### 8.2 P1 - 游戏功能

| 优先级 | 功能 | 预估时间 |
|--------|------|----------|
| **P1-1** | 倍率系统 (Multipliers区域) | 1天 |
| **P1-2** | 技能球 (SkillShot) | 4小时 |
| **P1-3** | 多球 (Multiballs) | 1天 |
| **P1-4** | 主菜单和UI | 2天 |
| **P1-5** | 音效系统 | 1天 |

### 8.3 P2 - 锦上添花

| 优先级 | 功能 | 预估时间 |
|--------|------|----------|
| **P2-1** | 全部5个区域 (完整关卡) | 3天 |
| **P2-2** | 角色系统 | 2天 |
| **P2-3** | 排行榜 | 1天 |
| **P2-4** | 成就系统 | 2天 |
| **P2-5** | 每日挑战 | 1天 |

---

## 9. 文件结构

### 9.1 目标Godot项目结构

```
pi-pin-ball/
├── assets/
│   ├── background/
│   ├── characters/
│   ├── ui/
│   └── tilesets/
├── audio/
│   ├── music/
│   └── sfx/
├── scenes/
│   ├── ui/
│   │   ├── MainMenu.tscn
│   │   ├── GameHUD.tscn
│   │   └── PauseMenu.tscn
│   ├── zones/
│   │   ├── GoogleGallery.tscn
│   │   ├── Multipliers.tscn
│   │   ├── SkillShot.tscn
│   │   ├── AndroidAcres.tscn
│   │   ├── DinoDesert.tscn
│   │   ├── FlutterForest.tscn
│   │   └── SparkyScorch.tscn
│   ├── components/
│   │   ├── Ball.tscn
│   │   ├── Flipper.tscn
│   │   ├── Launcher.tscn
│   │   └── Drain.tscn
│   └── Main.tscn
├── scripts/
│   ├── GameManager.gd
│   ├── Ball.gd
│   ├── Flipper.gd
│   ├── Launcher.gd
│   ├── ScoringArea.gd
│   └── zones/
├── levels/
└── project.godot
```

---

## 10. 关键代码片段

### 10.1 球物理 (Ball.gd)

```gdscript
extends RigidBody2D

@export var gravity_scale: float = 1.0
@export var bounce: float = 0.5
@export var friction: float = 0.1

func _ready() -> void:
    gravity_scale = ProjectSettings.get_setting("physics/2d/default_gravity_scale")
    physics_material_override = PhysicsMaterial.new()
    physics_material_override.bounce = bounce
    physics_material_override.friction = friction
    
    contact_monitor = true
    max_contacts_reported = 4
    
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
    if body is ScoringArea:
        var points = body.get_points()
        GameManager.add_score(points * GameManager.multiplier)
        show_score_popup(global_position, points * GameManager.multiplier)
```

### 10.2 挡板控制 (Flipper.gd)

```gdscript
extends StaticBody2D

@export var rest_angle: float = 0.0
@export var pressed_angle: float = 45.0
@export var rotation_speed: float = 30.0

var is_pressed: bool = false

func _physics_process(delta: float) -> void:
    var target_angle = pressed_angle if is_pressed else rest_angle
    rotation_degrees = move_toward(rotation_degrees, target_angle, rotation_speed * delta)

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept"):
        is_pressed = true
    elif event.is_action_released("ui_accept"):
        is_pressed = false
```

---

## 11. 测试用例

### 11.1 P0核心测试

| TC-ID | 测试项 | 预期结果 |
|-------|--------|----------|
| TC-P0-001 | 球发射 | 球从发射器射出 |
| TC-P0-002 | 挡板控制 | 按下空格挡板旋转 |
| TC-P0-003 | 碰撞检测 | 球撞击挡板反弹 |
| TC-P0-004 | 得分系统 | 撞击障碍物得分 |
| TC-P0-005 | 游戏结束 | 球掉落漏球口游戏结束 |

---

## 12. 下一步行动

### 立即执行

1. **创建Godot项目结构**
   - 初始化Godot 4.5项目
   - 创建基本目录结构

2. **实现P0-1: 物理引擎**
   - 创建Ball.tscn
   - 创建Flipper.tscn
   - 配置物理参数

3. **实现P0-2: 发射器**
   - 创建Launcher.tscn
   - 实现蓄力发射机制

### 本周目标

- 完成所有P0任务
- 实现核心游戏循环
- 验证游戏可运行

---

**分析完成时间:** 2026-02-19 12:30  
**下一步:** 开始实现Ball.tscn
