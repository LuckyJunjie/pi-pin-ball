extends Control

## MainMenu.gd - 主菜单
## 显示游戏主菜单

@onready var start_button: Button = $StartButton
@onready var title_label: Label = $Title
@onready var subtitle_label: Label = $Subtitle

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	
	# 设置焦点
	start_button.grab_focus()
	
	# 播放背景音乐
	GameManager.play_music("main_menu")

func _on_start_pressed() -> void:
	# 切换到主场景
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
