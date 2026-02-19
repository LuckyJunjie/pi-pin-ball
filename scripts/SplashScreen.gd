extends Control

## SplashScreen.gd - 启动画面
## 游戏启动时显示的加载画面

var load_progress: float = 0.0
var load_speed: float = 0.5

@onready var progress_bar: ProgressBar = $CenterContainer/VBox/ProgressBar
@onready var loading_label: Label = $CenterContainer/VBox/LoadingLabel

func _ready() -> void:
	# 开始加载流程
	_start_loading()

func _process(delta: float) -> void:
	# 更新加载进度
	load_progress += delta * load_speed
	if load_progress > 1.0:
		load_progress = 1.0
	
	# 更新进度条
	progress_bar.value = load_progress * 100
	
	# 更新文字
	if load_progress < 0.3:
		loading_label.text = "加载资源..."
	elif load_progress < 0.6:
		loading_label.text = "初始化游戏..."
	elif load_progress < 0.9:
		loading_label.text = "准备就绪..."
	else:
		loading_label.text = "进入游戏..."
	
	# 加载完成
	if load_progress >= 1.0:
		_finish_loading()

func _start_loading() -> void:
	load_progress = 0.0
	progress_bar.value = 0

func _finish_loading() -> void:
	# 等待一小段时间让用户看到100%
	await get_tree().create_timer(0.5).timeout
	
	# 切换到主菜单
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")

## 显示带有进度的加载（如果需要加载资源）
func set_progress(value: float) -> void:
	load_progress = value
	progress_bar.value = value * 100
