extends Node

## TutorialManager.gd - 新手引导系统
## 帮助新玩家了解游戏操作

enum TutorialStep {
	INTRO,
	MOVE_FLIPPERS,
	LAUNCH_BALL,
	FIRST_HIT,
	FIRST_COMBO,
	GAME_OVER
}

var current_step: TutorialStep = TutorialStep.INTRO
var tutorial_panels: Dictionary = {}

func _ready() -> void:
	_setup_tutorial_panels()

func _setup_tutorial_panels() -> void:
	tutorial_panels = {
		TutorialStep.INTRO: {
			"title": "🎮 欢迎来到 PI-PinBall!",
			"content": "这是一个弹球游戏，你的目标是用挡板击打球，获得尽可能高的分数！"
		},
		TutorialStep.MOVE_FLIPPERS: {
			"title": "🎯 控制挡板",
			"content": "按 A 键 控制左挡板\n按 空格键 控制右挡板\n\n挡住球，不要让它掉下去！"
		},
		TutorialStep.LAUNCH_BALL: {
			"title": "🚀 发射球",
			"content": "长按空格键蓄力\n松开后球会发射出去\n\n蓄力越久，球飞得越快！"
		},
		TutorialStep.FIRST_HIT: {
			"title": "💥 击中得分",
			"content": "球碰到墙壁、挡板或障碍物都会得分！\n\n击中特殊区域获得额外分数！"
		},
		TutorialStep.FIRST_COMBO: {
			"title": "🔥 连击系统",
			"content": "快速连续击中球会获得连击！\n\n连击数越高，得分倍率越高！"
		},
		TutorialStep.GAME_OVER: {
			"title": "🏁 游戏结束",
			"content": "所有球都掉落后游戏结束\n\n你可以选择重新开始或返回主菜单"
		}
	}

func start_tutorial() -> void:
	current_step = TutorialStep.INTRO
	show_current_step()

func show_current_step() -> void:
	if not tutorial_panels.has(current_step):
		return
	
	var panel_data = tutorial_panels[current_step]
	_show_tutorial_popup(panel_data["title"], panel_data["content"])

func _show_tutorial_popup(title: String, content: String) -> void:
	var popup = PanelContainer.new()
	popup.set_anchors_preset(Control.PRESET_CENTER)
	popup.custom_minimum_size = Vector2(500, 300)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 20)
	
	var title_label = Label.new()
	title_label.text = title
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 28)
	vbox.add_child(title_label)
	
	var content_label = Label.new()
	content_label.text = content
	content_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content_label.add_theme_font_size_override("font_size", 18)
	content_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(content_label)
	
	var continue_button = Button.new()
	continue_button.text = "继续 →"
	continue_button.pressed.connect(_on_continue)
	vbox.add_child(continue_button)
	
	popup.add_child(vbox)
	get_tree().current_scene.add_child(popup)

func _on_continue() -> void:
	# 隐藏当前教程面板
	for child in get_tree().current_scene.get_children():
		if child is PanelContainer and child.has_method("queue_free"):
			child.queue_free()
	
	# 进入下一步
	if current_step < TutorialStep.GAME_OVER:
		current_step += 1
		show_current_step()
	else:
		finish_tutorial()

func finish_tutorial() -> void:
	print("TutorialManager: 新手引导完成")
	# 保存教程完成状态

func skip_tutorial() -> void:
	for child in get_tree().current_scene.get_children():
		if child is PanelContainer:
			child.queue_free()
	finish_tutorial()

func is_tutorial_complete() -> bool:
	return current_step == TutorialStep.GAME_OVER
