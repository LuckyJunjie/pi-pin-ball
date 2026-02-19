extends Area2D

## ScoringArea.gd - 得分区域
## 当球碰撞时触发得分

## 信号
signal scored(points: int)

## 导出变量
@export_group("得分参数")
@export var base_points: int = 10000
@export var combo_multiplier: float = 1.0
@export var can_combo: bool = true

@export_group("视觉效果")
@export var show_popup: bool = true
@export var highlight_color: Color = Color.YELLOW

## 内部变量
var _hit_count: int = 0
var _last_hit_time: float = 0.0
var _combo_timeout: float = 2.0  # 连击超时时间

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	# 检查连击超时
	if can_combo and _hit_count > 0:
		var current_time: float = Time.get_ticks_msec() / 1000.0
		if current_time - _last_hit_time > _combo_timeout:
			_reset_combo()

func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D:  # 球是RigidBody2D
		# 检查是否是同一个球在短时间内连续碰撞
		var current_time: float = Time.get_ticks_msec() / 1000.0
		
		if can_combo:
			if current_time - _last_hit_time < _combo_timeout:
				_hit_count += 1
			else:
				_hit_count = 1
		
		_last_hit_time = current_time
		
		# 计算最终得分
		var final_points: int = _calculate_points()
		
		# 发送得分信号
		emit_signal("scored", final_points)
		
		# 通知GameManager
		GameManager.record_hit(self, final_points)
		
		# 显示视觉效果
		if show_popup:
			_show_hit_effect(body.global_position)

func _calculate_points() -> int:
	var combo_bonus: float = 1.0
	
	if can_combo and _hit_count > 1:
		combo_bonus = 1.0 + (_hit_count - 1) * 0.1  # 每个连击增加10%
	
	return int(base_points * combo_multiplier * combo_bonus)

func _reset_combo() -> void:
	_hit_count = 0

func _show_hit_effect(hit_position: Vector2) -> void:
	# 创建命中视觉效果
	var effect = HitEffect.new()
	effect.position = hit_position
	effect.modulate = highlight_color
	get_parent().add_child(effect)

## 公共方法

func get_points() -> int:
	return _calculate_points()

func get_hit_count() -> int:
	return _hit_count

func reset() -> void:
	_reset_combo()
