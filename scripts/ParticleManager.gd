extends Node

## ParticleManager.gd - 粒子特效管理器
## 管理游戏中的各种视觉特效

## 粒子预设
var particle_presets: Dictionary = {
	"score_pop": {
		"lifetime": 0.5,
		"speed": 100.0,
		"scale": 1.0,
		"color": Color(1, 1, 0)
	},
	"collision": {
		"lifetime": 0.3,
		"speed": 150.0,
		"scale": 0.8,
		"color": Color(1, 0.5, 0)
	},
	"combo": {
		"lifetime": 1.0,
		"speed": 200.0,
		"scale": 1.5,
		"color": Color(1, 0.2, 0.5)
	},
	"level_up": {
		"lifetime": 2.0,
		"speed": 300.0,
		"scale": 2.0,
		"color": Color(0.2, 1, 0.5)
	}
}

func _ready() -> void:
	print("ParticleManager: 初始化完成")

## 创建得分弹出特效
func create_score_pop(position: Vector2, points: int) -> void:
	# 创建得分数字特效
	var label = Label.new()
	label.text = "+" + str(points)
	label.position = position
	label.modulate = Color(1, 1, 0)
	label.add_theme_font_size_override("font_size", 24)
	
	# 添加动画
	var tween = create_tween()
	tween.tween_property(label, "position:y", position.y - 50, 0.5)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(label.queue_free)
	
	# 添加到场景
	get_tree().current_scene.add_child(label)

## 创建碰撞特效
func create_collision_effect(position: Vector2) -> void:
	# 创建简单的碰撞火花
	var sprite = ColorRect.new()
	sprite.color = Color(1, 0.5, 0)
	sprite.size = Vector2(20, 20)
	sprite.position = position
	
	var tween = create_tween()
	tween.tween_property(sprite, "size", Vector2(40, 40), 0.2)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.3)
	tween.tween_callback(sprite.queue_free)
	
	get_tree().current_scene.add_child(sprite)

## 创建连击特效
func create_combo_effect(combo_count: int) -> void:
	var label = Label.new()
	label.text = str(combo_count) + "x COMBO!"
	label.modulate = Color(1, 0.2, 0.5)
	label.add_theme_font_size_override("font_size", 32)
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.position = Vector2(576, 200)  # 屏幕中央
	
	var tween = create_tween()
	tween.tween_property(label, "position:y", 150, 1.0)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.0)
	tween.tween_callback(label.queue_free)
	
	get_tree().current_scene.add_child(label)

## 创建升级特效
func create_level_up_effect(level: int) -> void:
	var label = Label.new()
	label.text = "🎉 关卡 " + str(level) + " 🎉"
	label.modulate = Color(0.2, 1, 0.5)
	label.add_theme_font_size_override("font_size", 48)
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.position = Vector2(576, 324)
	
	var tween = create_tween()
	tween.tween_property(label, "scale", Vector2(1.5, 1.5), 0.5)
	tween.tween_property(label, "scale", Vector2(1, 1), 0.5)
	tween.tween_property(label, "modulate:a", 0.0, 2.0)
	tween.tween_callback(label.queue_free)
	
	get_tree().current_scene.add_child(label)

## 创建游戏结束特效
func create_game_over_effect() -> void:
	var label = Label.new()
	label.text = "GAME OVER"
	label.modulate = Color(1, 0.2, 0.2)
	label.add_theme_font_size_override("font_size", 64)
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.position = Vector2(576, 324)
	
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 3.0)
	tween.tween_callback(label.queue_free)
	
	get_tree().current_scene.add_child(label)
