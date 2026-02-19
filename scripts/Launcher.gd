extends Node2D

## Launcher.gd - 发射器
## 基于Flutter I/O Pinball的发射器实现

## 信号
signal launched(force: float)
signal ball_loaded()

## 导出变量
@export_group("发射参数")
@export var min_force: float = 500.0
@export var max_force: float = 1000.0
@export var charge_speed: float = 500.0

@export_group("位置")
@export var launch_position: Vector2 = Vector2(720, 450)
@export var ball_offset: Vector2 = Vector2(0, -20)

@export_group("输入")
@export var input_action: StringName = "ui_accept"

## 内部变量
var _charge_level: float = 0.0  # 0.0 - 1.0
var _is_charging: bool = false
var _has_ball: bool = false
var _ball_scene: PackedScene

func _ready() -> void:
	# 加载球场景
	_ball_scene = preload("res://scenes/components/Ball.tscn")
	
	# 设置位置
	position = launch_position

func _process(delta: float) -> void:
	_handle_input(delta)
	_update_charge(delta)

func _handle_input(delta: float) -> void:
	if Input.is_action_just_pressed(input_action):
		_start_charging()
	elif Input.is_action_just_released(input_action):
		_launch_ball()

func _start_charging() -> void:
	if _has_ball:
		_is_charging = true
		_charge_level = 0.0

func _update_charge(delta: float) -> void:
	if _is_charging:
		_charge_level += charge_speed * delta / max_force
		
		# 限制在0-1范围内
		_charge_level = clamp(_charge_level, 0.0, 1.0)
		
		# 达到最大时循环
		if _charge_level >= 1.0:
			_charge_level = 0.0

func _launch_ball() -> void:
	if not _is_charging or not _has_ball:
		return
	
	_is_charging = false
	
	# 计算发射力度
	var force: float = lerp(min_force, max_force, _charge_level)
	
	# 创建球
	var ball = _ball_scene.instantiate()
	ball.position = position + ball_offset
	ball.launch(force, Vector2.UP)  # 向上发射
	
	get_parent().add_child(ball)
	
	_has_ball = false
	_charge_level = 0.0
	
	emit_signal("launched", force)
	
	# 延迟加载新球
	get_tree().create_timer(2.0).timeout.connect(_load_ball)

func _load_ball() -> void:
	_has_ball = true
	emit_signal("ball_loaded")

## 公共方法

func get_charge_level() -> float:
	return _charge_level

func is_charging() -> bool:
	return _is_charging

func has_ball() -> bool:
	return _has_ball

func get_force() -> float:
	return lerp(min_force, max_force, _charge_level)

## 调试

func _draw() -> void:
	if OS.is_debug_build():
		# 绘制发射器
		draw_rect(Rect2(-10, -10, 20, 40), Color.BLUE)
		
		# 绘制力度条
		var bar_width: float = 100.0
		var bar_height: float = 10.0
		var bar_pos: Vector2 = Vector2(-50, 30)
		
		draw_rect(Rect2(bar_pos.x, bar_pos.y, bar_width, bar_height), Color.GRAY)
		draw_rect(Rect2(bar_pos.x, bar_pos.y, bar_width * _charge_level, bar_height), Color.GREEN)
