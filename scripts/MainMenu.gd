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
	
	# 播放菜单音乐 - 使用延迟调用确保 SoundManager 已加载
	if has_node("/root/SoundManager"):
		call_deferred("_play_menu_music")

func _process(_delta: float) -> void:
	# ESC键退出
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _play_menu_music() -> void:
	var sm = get_node("/root/SoundManager")
	if sm:
		sm.play_music("menu")

func _play_sound(sfx_name: String) -> void:
	var sm = get_node("/root/SoundManager")
	if sm:
		sm.play_sfx(sfx_name)

## 按钮回调

func _on_start_pressed() -> void:
	_play_sound("button_click")
	emit_signal("start_game_pressed")
	
	# 切换到游戏场景 - 添加错误处理
	var scene_path = "res://scenes/Main.tscn"
	print("[MainMenu] Attempting to change scene to: ", scene_path)
	
	if ResourceLoader.exists(scene_path):
		get_tree().change_scene_to_file(scene_path)
		print("[MainMenu] Scene change initiated successfully")
	else:
		push_error("[MainMenu] Scene file not found: ", scene_path)

func _on_instructions_pressed() -> void:
	_play_sound("button_click")
	emit_signal("instructions_pressed")
	
	# 显示操作说明
	_show_instructions()

func _on_settings_pressed() -> void:
	_play_sound("button_click")
	emit_signal("settings_pressed")
	
	# 打开设置菜单
	_show_settings()

func _on_quit_pressed() -> void:
	_play_sound("button_click")
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
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	var close_button = Button.new()
	close_button.text = "关闭"
	close_button.position = Vector2(250, 350)
	close_button.size = Vector2(100, 40)
	close_button.pressed.connect(panel.queue_free)
	
	panel.add_child(label)
	panel.add_child(close_button)
	add_child(panel)

func _show_settings() -> void:
	# 创建设置面板
	var panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.size = Vector2(500, 400)
	panel.color = Color(0.1, 0.1, 0.15, 0.95)
	
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 20)
	
	var title = Label.new()
	title.text = "⚙️ 设置"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	vbox.add_child(title)
	
	var sound_label = Label.new()
	sound_label.text = "🔊 音效音量"
	vbox.add_child(sound_label)
	
	var sound_slider = HSlider.new()
	sound_slider.min_value = 0
	sound_slider.max_value = 100
	sound_slider.value = 80
	sound_slider.custom_minimum_size = Vector2(300, 20)
	vbox.add_child(sound_slider)
	
	var music_label = Label.new()
	music_label.text = "🎵 音乐音量"
	vbox.add_child(music_label)
	
	var music_slider = HSlider.new()
	music_slider.min_value = 0
	music_slider.max_value = 100
	music_slider.value = 60
	music_slider.custom_minimum_size = Vector2(300, 20)
	vbox.add_child(music_slider)
	
	var spacer = Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(spacer)
	
	var close_button = Button.new()
	close_button.text = "关闭"
	close_button.custom_minimum_size = Vector2(150, 50)
	close_button.pressed.connect(panel.queue_free)
	vbox.add_child(close_button)
	
	panel.add_child(vbox)
	add_child(panel)

func _confirm_quit() -> bool:
	# 简单的确认对话框
	return true

## 公开接口

func set_version(version: String) -> void:
	version_label.text = version
