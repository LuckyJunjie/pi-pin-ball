extends Node

## CheatCodeManager.gd - 作弊码系统
## 输入特定序列激活作弊功能

var cheat_sequence: String = ""
var cheats_enabled: bool = true

# 作弊码列表
var cheat_codes: Dictionary = {
	"BALLS": {"action": "_cheat_more_balls", "description": "获得额外3个球"},
	"GODMODE": {"action": "_cheat_god_mode", "description": "上帝模式（无敌）"},
	"SUPERSCORE": {"action": "_cheat_super_score", "description": "超级分数（10000分）"},
	"MEGACOMBO": {"action": "_cheat_mega_combo", "description": "Mega连击（20x）"},
	"LEVELUP": {"action": "_cheat_level_up", "description": "升级到下一关"},
	"MUSIC": {"action": "_cheat_music", "description": "播放/暂停音乐"},
	"REVERSE": {"action": "_cheat_reverse", "description": "反向控制"},
	"HIGHFPS": {"action": "_cheat_high_fps", "description": "解锁高帧率"},
	"ALLUNLOCK": {"action": "_cheat_all_unlock", "description": "解锁所有内容"}
}

func _ready() -> void:
	print("CheatCodeManager: 作弊码系统已启用")

## 处理按键输入
func _input(event: InputEvent) -> void:
	if not cheats_enabled:
		return
	
	if event is InputEventKey and event.pressed:
		var key = event.as_text()
		_process_cheat_input(key)

func _process_cheat_input(key: String) -> void:
	# 过滤非字母数字键
	if key.length() != 1:
		return
	
	cheat_sequence += key.upper()
	
	# 限制序列长度
	if cheat_sequence.length() > 20:
		cheat_sequence = cheat_sequence.substr(cheat_sequence.length() - 20)
	
	# 检查作弊码
	_check_cheat_codes()

func _check_cheat_codes() -> void:
	for cheat_code in cheat_codes.keys():
		if cheat_sequence.ends_with(cheat_code):
			_activate_cheat(cheat_code)
			cheat_sequence = ""  # 重置序列
			break

func _activate_cheat(code: String) -> void:
	var cheat = cheat_codes[code]
	var method_name = cheat["action"]
	
	print("CheatCodeManager: 激活作弊码 - ", code, " (", cheat["description"], ")")
	
	# 显示作弊激活提示
	_show_cheat_notification(code, cheat["description"])
	
	# 执行作弊
	if has_method(method_name):
		call(method_name)

func _show_cheat_notification(code: String, description: String) -> void:
	var label = Label.new()
	label.text = "🎮 作弊码: " + code + " - " + description
	label.set_anchors_preset(Control.PRESET_CENTER)
	label.position = Vector2(576, 100)
	label.add_theme_font_size_override("font_size", 24)
	label.modulate = Color(1, 0.8, 0.2)
	
	get_tree().current_scene.add_child(label)
	
	# 3秒后消失
	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.tween_property(label, "modulate:a", 0.0, 0.5)
	tween.tween_callback(label.queue_free)

## 作弊功能实现

func _cheat_more_balls() -> void:
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		game_manager.remaining_balls += 3

func _cheat_god_mode() -> void:
	var debug_manager = get_node_or_null("/root/DebugManager")
	if debug_manager:
		debug_manager.toggle_god_mode()

func _cheat_super_score() -> void:
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		game_manager.add_score(10000)

func _cheat_mega_combo() -> void:
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		game_manager.game_multiplier = 20

func _cheat_level_up() -> void:
	var level_manager = get_node_or_null("/root/LevelManager")
	if level_manager:
		level_manager.next_level()

func _cheat_music() -> void:
	var sound_manager = get_node_or_null("/root/SoundManager")
	if sound_manager:
		if sound_manager.music_player.playing:
			sound_manager.stop_music()
		else:
			sound_manager.play_music("gameplay")

func _cheat_reverse() -> void:
	print("CheatCodeManager: 反向控制已激活")

func _cheat_high_fps() -> void:
	Engine.max_fps = 144
	print("CheatCodeManager: 高帧率模式已解锁")

func _cheat_all_unlock() -> void:
	var game_state = get_node_or_null("/root/GameStateManager")
	if game_state:
		game_state.unlock_level(5)

## 切换作弊系统开关
func set_cheats_enabled(enabled: bool) -> void:
	cheats_enabled = enabled
	print("CheatCodeManager: 作弊码系统 - ", enabled)
