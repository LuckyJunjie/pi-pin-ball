extends Node

## HintManager.gd - 提示系统
## 根据游戏情况提供智能提示

var hints: Dictionary = {
	"beginner": [
		"提示：按住空格键蓄力，松开发射！",
		"提示：A键控制左挡板，空格键控制右挡板！",
		"提示：连击可以获得更高的分数倍率！",
		"提示：击中顶部的特殊区域可以获得额外分数！"
	],
	"intermediate": [
		"提示：利用挡板的反弹角度可以更精准地控制球！",
		"提示：观察球的运动轨迹，预判落点！",
		"提示：不要急于击球，等待最佳时机！",
		"提示：保持节奏，不要盲目追求连击！"
	],
	"advanced": [
		"提示：利用墙壁角度可以创造意想不到的落点！",
		"提示：在球速较快时使用挡板可以增加反弹力量！",
		"提示：观察对手（AI）的策略，学习高级技巧！"
	]
}

var current_hint: String = ""
var hint_timer: float = 0.0
var show_hint_interval: float = 30.0  # 每30秒显示一次提示

func _ready() -> void:
	_show_random_hint()

func _process(delta: float) -> void:
	hint_timer += delta
	if hint_timer >= show_hint_interval:
		hint_timer = 0
		_show_random_hint()

func _show_random_hint() -> void:
	var hint_level = _get_hint_level()
	var hint_list = hints.get(hint_level, hints["beginner"])
	current_hint = hint_list.pick_random()
	_show_hint_popup(current_hint)

func _get_hint_level() -> String:
	# 根据玩家水平选择提示级别
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		var score = game_manager.get_score()
		if score < 1000:
			return "beginner"
		elif score < 5000:
			return "intermediate"
		else:
			return "advanced"
	return "beginner"

func _show_hint_popup(text: String) -> void:
	var popup = PanelContainer.new()
	popup.set_anchors_preset(Control.PRESET_CENTER)
	popup.position = Vector2(376, 50)  # 顶部居中
	
	var label = Label.new()
	label.text = "💡 " + text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 16)
	
	popup.add_child(label)
	
	# 添加到当前场景
	if get_tree().current_scene:
		get_tree().current_scene.add_child(popup)
		
		# 5秒后自动消失
		var tween = create_tween()
		tween.tween_interval(5.0)
		tween.tween_callback(popup.queue_free)

## 立即显示提示
func show_hint_now() -> void:
	_show_random_hint()

## 显示特定类型的提示
func show_hint_of_type(hint_type: String) -> void:
	if hints.has(hint_type):
		current_hint = hints[hint_type].pick_random()
		_show_hint_popup(current_hint)
