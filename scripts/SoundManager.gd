extends Node

## SoundManager.gd - 音效管理器
## 管理游戏中的音效播放

static var instance: SoundManager

var sfx_volume: float = 1.0
var music_volume: float = 0.8

# 音效映射
var sound_effects: Dictionary = {
	"flipper": preload("res://audio/sfx/flipper.wav"),
	"launch": preload("res://audio/sfx/launch.wav"),
	"bounce": preload("res://audio/sfx/bounce.wav"),
	"score": preload("res://audio/sfx/score.wav"),
	"combo": preload("res://audio/sfx/combo.wav"),
	"game_over": preload("res://audio/sfx/game_over.wav"),
	"lose_ball": preload("res://audio/sfx/lose_ball.wav"),
	"multiplier": preload("res://audio/sfx/multiplier.wav")
}

var current_music: String = ""
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

func _ready() -> void:
	instance = self
	
	# 创建音乐播放器
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# 创建音效播放器
	sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)

static func play_sfx(sound_name: String) -> void:
	if instance and instance.sfx_volume > 0:
		if instance.sound_effects.has(sound_name):
			var player = instance.sfx_player
			var stream = instance.sound_effects[sound_name]
			
			# 复制音频流以支持重叠播放
			var stream_copy = stream.duplicate()
			player.stream = stream_copy
			player.volume_db = linear_to_db(instance.sfx_volume)
			player.play()

static func play_music(music_name: String, loop: bool = true) -> void:
	if instance:
		instance.current_music = music_name
		instance.music_player.volume_db = linear_to_db(instance.music_volume)
		instance.music_player.loop = loop
		instance.music_player.play()

static func stop_music() -> void:
	if instance:
		instance.music_player.stop()

static func set_sfx_volume(volume: float) -> void:
	if instance:
		instance.sfx_volume = clamp(volume, 0.0, 1.0)

static func set_music_volume(volume: float) -> void:
	if instance:
		instance.music_volume = clamp(volume, 0.0, 1.0)
		if instance.music_player.playing:
			instance.music_player.volume_db = linear_to_db(instance.music_volume)

static func is_playing() -> bool:
	if instance:
		return instance.music_player.playing
	return false
