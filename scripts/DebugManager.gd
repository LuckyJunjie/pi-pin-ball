extends Node

## DebugManager.gd - 调试管理器
## 开发时使用的调试工具

var debug_enabled: bool = false
var show_fps: bool = false
var show_physics: bool = false
var god_mode: bool = false
var infinite_balls: bool = false
var score_multiplier: float = 1.0

func _ready() -> void:
	print("DebugManager: 初始化完成")

## 切换调试模式
func toggle_debug() -> void:
	debug_enabled = not debug_enabled
	print("DebugManager: 调试模式 - ", debug_enabled)

## 显示/隐藏FPS
func toggle_fps() -> void:
	show_fps = not show_fps
	print("DebugManager: FPS显示 - ", show_fps)

## 显示/隐藏物理调试
func toggle_physics_debug() -> void:
	show_physics = not show_physics
	get_tree().debug_collisions_visible = show_physics
	get_tree().debug_navigation_visible = show_physics
	print("DebugManager: 物理调试 - ", show_physics)

## 上帝模式（无敌）
func toggle_god_mode() -> void:
	god_mode = not god_mode
	print("DebugManager: 上帝模式 - ", god_mode)

## 无限球模式
func toggle_infinite_balls() -> void:
	infinite_balls = not infinite_balls
	print("DebugManager: 无限球 - ", infinite_balls)

## 设置分数倍率
func set_score_multiplier(mult: float) -> void:
	score_multiplier = mult
	print("DebugManager: 分数倍率 - ", mult, "x")

## 立即得分
func add_debug_score(points: int) -> void:
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager and game_manager.has_method("add_score"):
		game_manager.add_score(int(points * score_multiplier))
	print("DebugManager: 添加分数 - ", points * score_multiplier)

## 立即失败
func debug_game_over() -> void:
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager and game_manager.has_method("end_game"):
		game_manager.end_game()

## 打印游戏状态
func print_game_state() -> void:
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		print("=== 游戏状态 ===")
		print("分数: ", game_manager.get_score())
		print("最高分: ", game_manager.get_high_score())
		print("剩余球: ", game_manager.get_remaining_balls())
		print("游戏状态: ", game_manager.current_state)
		print("================")

## 处理调试输入
func _input(event: InputEvent) -> void:
	if not debug_enabled:
		return
	
	# F1: 切换调试
	if event.is_action_pressed("ui_f1"):
		toggle_debug()
	
	# F2: 切换FPS
	if event.is_action_pressed("ui_f2"):
		toggle_fps()
	
	# F3: 切换物理调试
	if event.is_action_pressed("ui_f3"):
		toggle_physics_debug()
	
	# F4: 上帝模式
	if event.is_action_pressed("ui_f4"):
		toggle_god_mode()
	
	# F5: 无限球
	if event.is_action_pressed("ui_f5"):
		toggle_infinite_balls()
	
	# F6: 添加1000分
	if event.is_action_pressed("ui_f6"):
		add_debug_score(1000)
	
	# F7: 游戏结束
	if event.is_action_pressed("ui_f7"):
		debug_game_over()
	
	# F8: 打印状态
	if event.is_action_pressed("ui_f8"):
		print_game_state()
