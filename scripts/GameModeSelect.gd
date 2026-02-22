extends Control

## GameModeSelect.gd - 游戏模式选择界面
## 选择游戏模式和难度

signal mode_selected(mode: int, difficulty: int)
signal back_pressed()

var selected_mode: int = 0  # Classic
var selected_difficulty: int = 1  # Normal

@onready var grid: GridContainer = $ModeGrid

func _ready() -> void:
	_create_mode_buttons()
	$BackButton.pressed.connect(_on_back_pressed)

func _create_mode_buttons() -> void:
	var modes = [
		{"id": 0, "name": "🎯 经典模式", "desc": "标准玩法，3个球"},
		{"id": 1, "name": "🧘 禅模式", "desc": "无限球，放松练习"},
		{"id": 2, "name": "⚔️ 挑战模式", "desc": "限时60秒"},
		{"id": 3, "name": "⏱️ 计时攻击", "desc": "3分钟内得分"}
	]
	
	for mode in modes:
		var button = Button.new()
		button.custom_minimum_size = Vector2(250, 100)
		button.pressed.connect(_on_mode_selected.bind(mode["id"]))
		
		var vbox = VBoxContainer.new()
		
		var name_label = Label.new()
		name_label.text = mode["name"]
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_size_override("font_size", 20)
		vbox.add_child(name_label)
		
		var desc_label = Label.new()
		desc_label.text = mode["desc"]
		desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		desc_label.add_theme_font_size_override("font_size", 14)
		vbox.add_child(desc_label)
		
		button.add_child(vbox)
		grid.add_child(button)

func _on_mode_selected(mode_id: int) -> void:
	selected_mode = mode_id
	# 发送模式选择信号
	mode_selected.emit(selected_mode, selected_difficulty)
	
	# 切换场景 - 添加错误处理
	var scene_path = "res://scenes/Main.tscn"
	print("[GameModeSelect] Attempting to change scene to: ", scene_path)
	
	if ResourceLoader.exists(scene_path):
		get_tree().change_scene_to_file(scene_path)
		print("[GameModeSelect] Scene change initiated successfully")
	else:
		push_error("[GameModeSelect] Scene file not found: ", scene_path)

func _on_back_pressed() -> void:
	back_pressed.emit()
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
