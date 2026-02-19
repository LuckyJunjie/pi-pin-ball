extends StaticBody2D

## Flipper.gd - 挡板控制
## 基于Flutter I/O Pinball的挡板实现

## 导出变量
@export_group("角度参数")
@export var rest_angle: float = 0.0           # 静止角度
@export var pressed_angle: float = 45.0        # 按下角度
@export var max_rotation: float = 60.0          # 最大旋转角度

@export_group("物理参数")
@export var rotation_speed: float = 30.0        # 旋转速度 (度/秒)
@export var impact_force: float = 500.0         # 碰撞时施加的力

@export_group("输入")
@export var input_action: StringName = "ui_accept"  # 输入动作名称

## 信号
signal flipped(is_pressed: bool)
signal hit_ball(ball: RigidBody2D)

## 内部变量
var _is_pressed: bool = false
var _is_rotating: bool = false
var _current_rotation: float = 0.0

## 生命周期

func _ready() -> void:
	# 设置碰撞层和掩码
	collision_layer = 2
	collision_mask = 1  # 只检测球 (层1)
	
	# 初始化旋转
	rotation_degrees = rest_angle
	_current_rotation = rest_angle

func _physics_process(delta: float) -> void:
	_handle_input(delta)
	_update_rotation(delta)

func _handle_input(delta: float) -> void:
	var was_pressed: bool = _is_pressed
	_is_pressed = Input.is_action_pressed(input_action)
	
	# 检测状态变化
	if was_pressed != _is_pressed:
		emit_signal("flipped", _is_pressed)

func _update_rotation(delta: float) -> void:
	var target_angle: float = pressed_angle if _is_pressed else rest_angle
	
	# 平滑旋转
	_current_rotation = move_toward(_current_rotation, target_angle, rotation_speed * delta)
	rotation_degrees = _current_rotation
	
	# 更新旋转状态
	_is_rotating = abs(_current_rotation - target_angle) > 0.5

## 碰撞处理

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D:
		# 挡板碰撞
		if _is_pressed and _is_rotating:
			# 如果挡板正在旋转，施加额外的力
			_apply_ball_force(body)
		
		# 发送碰撞信号
		emit_signal("hit_ball", body)
		
		# 播放音效
		GameManager.play_sound("flipper_click")

func _apply_ball_force(ball: RigidBody2D) -> void:
	# 计算力的方向和大小
	var force_direction: Vector2 = (ball.global_position - global_position).normalized()
	var force_magnitude: float = impact_force
	
	# 施加脉冲
	ball.apply_central_impulse(force_direction * force_magnitude)

## 公共方法

func is_pressed() -> bool:
	return _is_pressed

func is_rotating() -> bool:
	return _is_rotating

func get_current_angle() -> float:
	return _current_rotation

func get_rotation_speed() -> float:
	return rotation_speed

## 调试

func _draw() -> void:
	if OS.is_debug_build():
		# 绘制挡板中心和旋转轴
		draw_line(Vector2.ZERO, Vector2(50, 0), Color.GREEN, 2.0)
