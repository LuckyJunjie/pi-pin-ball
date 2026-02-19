extends Control

## MainMenu.gd - 主菜单界面
## 管理主菜单的UI交互

## 信号
signal start_game_pressed()
signal instructions_pressed()
signal settings_pressed()
signal quit_pressed()

## 节点引用
@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var start_button: Button = $MarginContainer/VBoxContainer/ButtonContainer/StartButton
@onready var instructions_button: Button = $MarginContainer/VBoxContainer/ButtonContainer/InstructionsButton
@onready var settings_button: Button = $MarginContainer/VBoxContainer/ButtonContainer/SettingsButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/ButtonContainer/QuitButton
@onready var version_label: Label = $MarginContainer/VBoxContainer/VersionLabel

## 生命周期

func _ready() -> void:
	# 连接按钮信号
	start_button.pressed.connect(_on_start_pressed)
	instructions_button.pressed.connect(_on_instructions_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# 设置版本信息
	version_label.text = "v0.1.0"
	
	# 播放菜单音乐
	SoundManager.play_music("menu")

func _process(_delta: float) -> void:
	# ESC键退出
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

## 按钮回调

func _on_start_pressed() -> void:
	SoundManager.play_sfx("button_click")
	emit_signal("start_game_pressed")
	
	# 切换到游戏场景
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_instructions_pressed() -> void:
	SoundManager.play_sfx("button_click")
	emit_signal("instructions_pressed")
	
	# 显示操作说明
	_show_instructions()

func _on_settings_pressed() -> void:
	SoundManager.play_sfx("button_click")
	emit_signal("settings_pressed")
	
	# 打开设置菜单
	_show_settings()

func _on_quit_pressed() -> void:
	SoundManager.play_sfx("button_click")
	emit_signal("quit_pressed")
	
	# 确认退出
	if _confirm_quit():
		get_tree().quit()

## 辅助函数

func _show_instructions() -> void:
	var panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.size = Vector2(600, 400)
	
	var label = Label.new()
	label.text = """
🎮 操作说明

⏪ 左挡板: A键
⏩ 右挡板: 空格键
🚀 发射球: 空格键 (长按蓄力)
⏸️ 暂停: ESC键

🎯 游戏目标

使用挡板击打弹珠，
获得尽可能高的分数！

💡 提示

- 连击可以提升倍率
- 击中特殊区域获得额外分数
- 保持小球不落入底部
"""
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.horizontal_alignment = HorizontalAlignment.CENTER
	label.vertical_alignment = VerticalAlignment.CENTER
	
	var close_button = Button.new()
	close_button.text = "关闭"
	close_button.position = Vector2(250, 350)
	close_button.size = Vector2(100, 40)
	close_button.pressed.connect(panel.queue_free)
	
	panel.add_child(label)
	panel.add_child(close_button)
	add_child(panel)

func _show_settings() -> void:
	# TODO: 实现设置菜单
	print("Settings menu - TODO")

func _confirm_quit() -> bool:
	# 简单的确认对话框
	return true

## 公开接口

func set_version(version: String) -> void:
	version_label.text = version
