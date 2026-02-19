extends Control

## SettingsUI.gd - 设置界面
## 游戏设置管理

signal back_pressed()
signal settings_changed()

var settings_manager = null

@onready var sfx_slider: HSlider = $SettingsScroll/SettingsVBox/SoundSection/SFXSlider
@onready var music_slider: HSlider = $SettingsScroll/SettingsVBox/SoundSection/MusicSlider
@onready var fullscreen_check: CheckBox = $SettingsScroll/SettingsVBox/DisplaySection/FullscreenCheck
@onready var vsync_check: CheckBox = $SettingsScroll/SettingsVBox/DisplaySection/VSYNCCheck

func _ready() -> void:
	_load_settings()
	_connect_signals()

func _connect_signals() -> void:
	$BackButton.pressed.connect(_on_back_pressed)
	
	# 音效设置
	sfx_slider.value_changed.connect(_on_sfx_changed)
	music_slider.value_changed.connect(_on_music_changed)
	
	# 显示设置
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	vsync_check.toggled.connect(_on_vsync_toggled)

func _load_settings() -> void:
	# 获取设置管理器
	settings_manager = get_node_or_null("/root/SettingsManager")
	
	if settings_manager:
		sfx_slider.value = settings_manager.get_sfx_volume() * 100
		music_slider.value = settings_manager.get_music_volume() * 100
		fullscreen_check.button_pressed = settings_manager.is_fullscreen()
	else:
		sfx_slider.value = 80
		music_slider.value = 60
		fullscreen_check.button_pressed = false
		vsync_check.button_pressed = true

func _on_sfx_changed(value: float) -> void:
	if settings_manager:
		settings_manager.set_sfx_volume(value / 100)
	settings_changed.emit()

func _on_music_changed(value: float) -> void:
	if settings_manager:
		settings_manager.set_music_volume(value / 100)
	settings_changed.emit()

func _on_fullscreen_toggled(toggled: bool) -> void:
	if settings_manager:
		settings_manager.set_fullscreen(toggled)
	
	# 应用全屏设置
	if toggled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	settings_changed.emit()

func _on_vsync_toggled(toggled: bool) -> void:
	# 应用垂直同步
	if toggled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	settings_changed.emit()

func _on_back_pressed() -> void:
	# 保存设置
	if settings_manager:
		settings_manager.save_settings()
	
	back_pressed.emit()
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
