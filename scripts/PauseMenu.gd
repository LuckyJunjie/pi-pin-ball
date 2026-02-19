extends CanvasLayer

## PauseMenu.gd - 暂停菜单
## 游戏暂停时显示的菜单界面

signal resume_game()
signal restart_game()
signal open_settings()
signal return_to_main_menu()
signal quit_game()

@onready var background: ColorRect = $Background
@onready var resume_button: Button = $CenterContainer/VBox/ResumeButton
@onready var restart_button: Button = $CenterContainer/VBox/RestartButton
@onready var settings_button: Button = $CenterContainer/VBox/SettingsButton
@onready var main_menu_button: Button = $CenterContainer/VBox/MainMenuButton
@onready var quit_button: Button = $CenterContainer/VBox/QuitButton

func _ready() -> void:
	# 连接按钮信号
	resume_button.pressed.connect(_on_resume_pressed)
	restart_button.pressed.connect(_on_restart_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# 连接键盘快捷键
	resume_button.shortcut = _create_shortcut(KEY_ESCAPE)
	resume_button.shortcut_tooltip = "按ESC继续游戏"

func _create_shortcut(key: int) -> InputEventKey:
	var event = InputEventKey.new()
	event.keycode = key
	return event

func _on_resume_pressed() -> void:
	resume_game.emit()
	queue_free()

func _on_restart_pressed() -> void:
	restart_game.emit()
	queue_free()

func _on_settings_pressed() -> void:
	open_settings.emit()

func _on_main_menu_pressed() -> void:
	return_to_main_menu.emit()
	queue_free()

func _on_quit_pressed() -> void:
	quit_game.emit()

## 显示菜单
func show_pause_menu() -> void:
	visible = true
	get_tree().paused = true

## 隐藏菜单
func hide_pause_menu() -> void:
	visible = false
	get_tree().paused = false
