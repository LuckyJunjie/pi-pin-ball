extends Control

## LevelSelect.gd - 关卡选择界面
## 管理关卡选择UI交互

signal level_selected(level: int)
signal back_pressed()

var levels: Array[Dictionary] = []
var level_buttons: Array[Button] = []

@onready var grid: GridContainer = $LevelGrid

func _ready() -> void:
	# 加载关卡数据
	_load_levels()
	
	# 创建关卡按钮
	_create_level_buttons()
	
	# 连接返回按钮
	$BackButton.pressed.connect(_on_back_pressed)

func _load_levels() -> void:
	levels = [
		{"level": 1, "name": "Android Acres", "difficulty": "简单", "unlocked": true},
		{"level": 2, "name": "Flutter Forest", "difficulty": "中等", "unlocked": true},
		{"level": 3, "name": "Dart Canyon", "difficulty": "困难", "unlocked": false},
		{"level": 4, "name": "Firebase Falls", "difficulty": "专家", "unlocked": false},
		{"level": 5, "name": "Google Gardens", "difficulty": "大师", "unlocked": false}
	]

func _create_level_buttons() -> void:
	for level_data in levels:
		var button = Button.new()
		button.custom_minimum_size = Vector2(120, 100)
		
		if not level_data["unlocked"]:
			button.disabled = true
		
		button.pressed.connect(_on_level_pressed.bind(level_data["level"]))
		
		# 创建按钮内容
		var vbox = VBoxContainer.new()
		
		var level_label = Label.new()
		level_label.text = "关卡 " + str(level_data["level"])
		level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		level_label.add_theme_font_size_override("font_size", 24)
		vbox.add_child(level_label)
		
		var name_label = Label.new()
		name_label.text = level_data["name"]
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_size_override("font_size", 14)
		vbox.add_child(name_label)
		
		var diff_label = Label.new()
		diff_label.text = level_data["difficulty"]
		diff_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		diff_label.add_theme_font_size_override("font_size", 12)
		vbox.add_child(diff_label)
		
		button.add_child(vbox)
		grid.add_child(button)
		level_buttons.append(button)

func _on_level_pressed(level: int) -> void:
	print("LevelSelect: 选择关卡 - ", level)
	level_selected.emit(level)
	
	# 切换到游戏场景
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_back_pressed() -> void:
	back_pressed.emit()
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")

func unlock_level(level: int) -> void:
	if level > 0 and level <= levels.size():
		levels[level - 1]["unlocked"] = true
		_create_level_buttons()
