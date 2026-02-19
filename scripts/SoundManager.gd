extends Node

## SoundManager.gd - 音效管理系统
## 管理游戏中的所有音效和音乐播放

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

## 音效配置
var sfx_volume: float = 0.8
var music_volume: float = 0.6

## 模拟音效（无实际音频文件时使用）
var sfx_playing: bool = false

func _ready() -> void:
	# 创建音乐播放器
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.bus = "Master"
	add_child(music_player)
	
	# 创建音效播放器
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SFXPlayer"
	sfx_player.bus = "Master"
	add_child(sfx_player)
	
	print("SoundManager: 初始化完成")

## 播放音效
func play_sfx(sound_name: String) -> void:
	if sfx_volume <= 0:
		return
	
	print("SoundManager: 播放音效 - ", sound_name)
	# 实际项目中这里会播放具体的音频文件
	# 比如: sfx_player.stream = load("res://assets/audio/" + sound_name + ".wav")

## 播放背景音乐
func play_music(track_name: String) -> void:
	if music_volume <= 0:
		return
	
	print("SoundManager: 播放音乐 - ", track_name)
	# 实际项目中这里会播放具体的音频文件

## 停止音乐
func stop_music() -> void:
	music_player.stop()

## 设置音效音量
func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)
	print("SoundManager: 音效音量 - ", sfx_volume)

## 设置音乐音量
func set_music_volume(volume: float) -> void:
	music_volume = clamp(volume, 0.0, 1.0)
	music_player.volume_db = linear_to_db(music_volume)
	print("SoundManager: 音乐音量 - ", music_volume)

## 播放游戏音效 - 球发射
func play_launch() -> void:
	play_sfx("launch")

## 播放游戏音效 - 挡板击打
func play_flipper() -> void:
	play_sfx("flipper")

## 播放游戏音效 - 碰撞
func play_collision() -> void:
	play_sfx("collision")

## 播放游戏音效 - 得分
func play_score() -> void:
	play_sfx("score")

## 播放游戏音效 - 连击
func play_combo() -> void:
	play_sfx("combo")

## 播放游戏音效 - 游戏结束
func play_game_over() -> void:
	play_sfx("game_over")

## 播放游戏音效 - 按钮点击
func play_button_click() -> void:
	play_sfx("button_click")

## 播放游戏音效 - 关卡通过
func play_level_complete() -> void:
	play_sfx("level_complete")
