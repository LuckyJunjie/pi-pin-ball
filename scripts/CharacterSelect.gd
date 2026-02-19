extends Control

## CharacterSelect.gd - 角色选择界面
## 管理角色选择UI交互

signal character_selected(character_id: String)
signal back_pressed()

var characters: Dictionary = {}
var character_buttons: Array[Button] = []

@onready var grid: GridContainer = $CharacterGrid

func _ready() -> void:
	# 加载角色数据
	_load_characters()
	
	# 创建角色按钮
	_create_character_buttons()
	
	# 连接返回按钮
	$BackButton.pressed.connect(_on_back_pressed)

func _load_characters() -> void:
	characters = {
		"default": {"name": "默认角色", "color": Color.RED, "desc": "标准弹球角色"},
		"speedy": {"name": "闪电侠", "color": Color.YELLOW, "desc": "球速提升20%"},
		"lucky": {"name": "幸运儿", "color": Color.GREEN, "desc": "得分提升20%"},
		"magnet": {"name": "磁铁人", "color": Color.MAGENTA, "desc": "吸附球更容易"},
		"guardian": {"name": "守护者", "color": Color.BLUE, "desc": "额外生命+1"}
	}

func _create_character_buttons() -> void:
	for char_id in characters.keys():
		var char_data = characters[char_id]
		
		var button = Button.new()
		button.custom_minimum_size = Vector2(150, 120)
		button.pressed.connect(_on_character_pressed.bind(char_id))
		
		# 创建按钮内容
		var vbox = VBoxContainer.new()
		
		var name_label = Label.new()
		name_label.text = char_data["name"]
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(name_label)
		
		var desc_label = Label.new()
		desc_label.text = char_data["desc"]
		desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		desc_label.add_theme_font_size_override("font_size", 12)
		vbox.add_child(desc_label)
		
		button.add_child(vbox)
		grid.add_child(button)
		character_buttons.append(button)

func _on_character_pressed(character_id: String) -> void:
	print("CharacterSelect: 选择角色 - ", character_id)
	character_selected.emit(character_id)
	
	# 切换到游戏场景
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_back_pressed() -> void:
	back_pressed.emit()
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
