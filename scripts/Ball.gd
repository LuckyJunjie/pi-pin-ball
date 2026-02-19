extends RigidBody2D

## Ball.gd - 弹珠机球
## 基于Flutter I/O Pinball的球物理实现

## 信号
signal destroyed

## 导出变量
@export_group("物理参数")
@export var gravity_scale: float = 1.0
@export var bounce: float = 0.5
@export var friction: float = 0.1
@export var linear_damp: float = 0.0
@export var angular_damp: float = 0.0

@export_group("游戏参数")
@export var layer: int = 0
@export var z_index: int = 10

## 内部变量
var _is_destroyed: bool = false
var _scored_areas: Array[Node] = []

## 生命周期

func _ready() -> void:
	# 配置物理属性
	_setup_physics()
	
	# 设置碰撞层
	collision_layer = 1
	collision_mask = 1 | 2 | 4  # 碰撞层: 挡板=2, 墙壁=4
	
	# 连接信号
	body_entered.connect(_on_body_entered)

func _setup_physics() -> void:
	# 应用物理材质
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.bounce = bounce
	physics_material_override.friction = friction
	
	# 应用重力
	gravity_scale = ProjectSettings.get_setting("physics/2d/default_gravity_scale")
	linear_damp = linear_damp
	angular_damp = angular_damp
	
	# 启用碰撞检测
	contact_monitor = true
	max_contacts_reported = 4

## 碰撞处理

func _on_body_entered(body: Node) -> void:
	if _is_destroyed:
		return
	
	# 处理得分区域
	if body is ScoringArea:
		_handle_scoring_area(body)
	
	# 处理挡板
	elif body is Flipper:
		_handle_flipper_collision(body)
	
	# 处理漏球口
	elif body.name == "Drain":
		_handle_drain_collision()

func _handle_scoring_area(area: ScoringArea) -> void:
	# 避免重复得分
	if area in _scored_areas:
		return
	
	_scored_areas.append(area)
	
	# 计算得分
	var points: int = area.get_points()
	var total_points: int = points * GameManager.get_multiplier()
	
	# 更新分数
	GameManager.add_score(total_points)
	
	# 显示分数动画
	_show_score_popup(global_position, total_points)
	
	# 播放音效
	GameManager.play_sound("obstacle_hit")

func _handle_flipper_collision(flipper: Flipper) -> void:
	# 挡板碰撞，增加弹射力
	if flipper.is_rotating():
		_apply_flipper_force(flipper)
	
	# 播放音效
	GameManager.play_sound("flipper_click")

func _handle_drain_collision() -> void:
	# 球掉落，游戏结束
	GameManager.ball_lost()
	queue_free()

func _apply_flipper_force(flipper: Flipper) -> void:
	# 计算弹射方向和力度
	var force_direction: Vector2 = (global_position - flipper.global_position).normalized()
	var force_magnitude: float = 500.0
	
	apply_central_impulse(force_direction * force_magnitude)

## 分数动画

func _show_score_popup(position: Vector2, points: int) -> void:
	# 创建分数弹出效果
	var popup = ScorePopup.new()
	popup.position = position
	popup.setup(points)
	get_parent().add_child(popup)

## 公共方法

func launch(force: float, direction: Vector2) -> void:
	# 发射球
	apply_central_impulse(direction * force)

func reset() -> void:
	# 重置球状态
	_is_destroyed = false
	_scored_areas.clear()
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

func destroy() -> void:
	# 销毁球
	_is_destroyed = true
	emit_signal("destroyed")
	queue_free()

## 调试

func _draw() -> void:
	# 如果在编辑器中或调试模式，绘制球
	if OS.is_debug_build():
		draw_circle(Vector2.ZERO, 10.0, Color.RED)
