extends Control

## AchievementUI.gd - 成就界面
## 显示和管理玩家成就

signal back_pressed()

var achievements: Dictionary = {}

@onready var grid: GridContainer = $AchievementGrid

func _ready() -> void:
	# 加载成就数据
	_load_achievements()
	
	# 创建成就显示
	_create_achievement_display()
	
	# 连接返回按钮
	$BackButton.pressed.connect(_on_back_pressed)

func _load_achievements() -> void:
	# 从GameStateManager获取成就数据
	var game_state = get_node_or_null("/root/GameStateManager")
	if game_state and game_state.has_method("get_achievements"):
		achievements = game_state.get_achievements()
	else:
		# 默认成就数据
		achievements = {
			"first_game": {"name": "初学者", "description": "完成第一局游戏", "unlocked": false},
			"score_1000": {"name": "千里挑一", "description": "单局得分超过1000", "unlocked": false},
			"score_5000": {"name": "万分达人", "description": "单局得分超过5000", "unlocked": false},
			"score_10000": {"name": "万分大师", "description": "单局得分超过10000", "unlocked": false},
			"combo_5": {"name": "五连击", "description": "达成5连击", "unlocked": false},
			"combo_10": {"name": "十连击", "description": "达成10连击", "unlocked": false},
			"level_2": {"name": "进阶玩家", "description": "解锁第2关", "unlocked": false},
			"level_3": {"name": "高手", "description": "解锁第3关", "unlocked": false},
			"all_levels": {"name": "关卡大师", "description": "解锁所有关卡", "unlocked": false},
			"play_10_games": {"name": "老玩家", "description": "完成10局游戏", "unlocked": false}
		}

func _create_achievement_display() -> void:
	for ach_id in achievements.keys():
		var ach_data = achievements[ach_id]
		
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(350, 80)
		
		var hbox = HBoxContainer.new()
		
		# 成就图标
		var icon = Label.new()
		if ach_data["unlocked"]:
			icon.text = "✅"
		else:
			icon.text = "🔒"
		icon.add_theme_font_size_override("font_size", 32)
		hbox.add_child(icon)
		
		# 成就信息
		var vbox = VBoxContainer.new()
		
		var name_label = Label.new()
		name_label.text = ach_data["name"]
		name_label.add_theme_font_size_override("font_size", 18)
		vbox.add_child(name_label)
		
		var desc_label = Label.new()
		desc_label.text = ach_data["description"]
		desc_label.add_theme_font_size_override("font_size", 14)
		desc_label.modulate = Color(0.7, 0.7, 0.7)
		vbox.add_child(desc_label)
		
		hbox.add_child(vbox)
		panel.add_child(hbox)
		
		# 未解锁的成就透明度降低
		if not ach_data["unlocked"]:
			panel.modulate = Color(0.5, 0.5, 0.5)
		
		grid.add_child(panel)

func _on_back_pressed() -> void:
	back_pressed.emit()
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
