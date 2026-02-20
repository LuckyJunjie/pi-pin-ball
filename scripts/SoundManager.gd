extends Node
class_name SoundManager

## SoundManager.gd - 音效管理系统
## 管理游戏中的所有音效和音乐播放
## 使用方法: SoundManager.play_sfx("sound_name")

## 单例模式
static var instance: SoundManager

## 音频播放器
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []  # 多个音效播放器支持同时播放

## 音量设置
var sfx_volume: float = 0.8
var music_volume: float = 0.6

## 音效池配置
const SFX_POOL_SIZE: int = 4

func _ready() -> void:
	instance = self
	_setup_audio_players()
	print("SoundManager: 初始化完成")

func _setup_audio_players() -> void:
	# 创建音乐播放器
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Master"
	music_player.volume_db = linear_to_db(music_volume)
	add_child(music_player)
	
	# 创建音效播放器池
	for i in range(SFX_POOL_SIZE):
		var player = AudioStreamPlayer.new()
		player.name = "SFXPlayer_" + str(i)
		player.bus = "Master"
		player.volume_db = linear_to_db(sfx_volume)
		add_child(player)
		sfx_players.append(player)

## 播放音效 - 静态方法供外部调用
static func play_sfx(sound_name: String) -> void:
	if instance:
		instance._play_sfx_internal(sound_name)

## 播放背景音乐 - 静态方法供外部调用
static func play_music(track_name: String) -> void:
	if instance:
		instance._play_music_internal(track_name)

## 停止音乐 - 静态方法供外部调用
static func stop_music() -> void:
	if instance:
		instance.music_player.stop()

## 内部播放音效
func _play_sfx_internal(sound_name: String) -> void:
	if sfx_volume <= 0:
		return
	
	# 查找空闲的播放器
	var player = _get_available_sfx_player()
	if player:
		# 尝试加载音效文件
		var sound_path = "res://assets/audio/sfx/" + sound_name + ".wav"
		if ResourceLoader.exists(sound_path):
			player.stream = load(sound_path)
			player.play()
			print("SoundManager: 播放音效 - ", sound_name)
		else:
			print("SoundManager: 音效文件不存在 - ", sound_path)
	else:
		print("SoundManager: 所有音效播放器都忙碌")

## 内部播放音乐
func _play_music_internal(track_name: String) -> void:
	if music_volume <= 0:
		return
	
	var music_path = "res://assets/audio/music/" + track_name + ".ogg"
	if ResourceLoader.exists(music_path):
		music_player.stream = load(music_path)
		music_player.play()
		print("SoundManager: 播放音乐 - ", track_name)
	else:
		print("SoundManager: 音乐文件不存在 - ", music_path)

## 获取可用的音效播放器
func _get_available_sfx_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if not player.playing:
			return player
	return sfx_players[0]  # 返回第一个（会覆盖）

## 设置音效音量
static func set_sfx_volume(volume: float) -> void:
	if instance:
		instance.sfx_volume = clamp(volume, 0.0, 1.0)
		for player in instance.sfx_players:
			player.volume_db = linear_to_db(instance.sfx_volume)
		print("SoundManager: 音效音量 - ", instance.sfx_volume)

## 设置音乐音量
static func set_music_volume(volume: float) -> void:
	if instance:
		instance.music_volume = clamp(volume, 0.0, 1.0)
		instance.music_player.volume_db = linear_to_db(instance.music_volume)
		print("SoundManager: 音乐音量 - ", instance.music_volume)

## 便捷方法 - 游戏音效

static func play_launch() -> void:
	play_sfx("launch")

static func play_flipper() -> void:
	play_sfx("flipper")

static func play_collision() -> void:
	play_sfx("collision")

static func play_score() -> void:
	play_sfx("score")

static func play_combo() -> void:
	play_sfx("combo")

static func play_game_over() -> void:
	play_sfx("game_over")

static func play_button_click() -> void:
	play_sfx("button_click")

static func play_level_complete() -> void:
	play_sfx("level_complete")

static func play_multiplier() -> void:
	play_sfx("multiplier")

static func play_lose_ball() -> void:
	play_sfx("lose_ball")
