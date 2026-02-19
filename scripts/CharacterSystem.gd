extends Node

## CharacterSystem.gd - 角色系统
## 管理游戏中的角色选择和属性

signal character_selected(character_id: String)
signal character_changed(old_id: String, new_id: String)

## 可用角色
var characters: Dictionary = {
	"default": {
		"name": "Default",
		"display_name": "默认角色",
		"description": "标准弹球角色",
		"color": Color(1, 1, 1),
		"ball_color": Color(1, 0.2, 0.2),
		"multiplier": 1.0,
		"special_ability": ""
	},
	"speedy": {
		"name": "Speedy",
		"display_name": "闪电侠",
		"description": "球速提升20%",
		"color": Color(1, 0.9, 0.2),
		"ball_color": Color(1, 0.9, 0.2),
		"multiplier": 1.0,
		"special_ability": "speed_boost"
	},
	"lucky": {
		"name": "Lucky", 
		"display_name": "幸运儿",
		"description": "得分提升20%",
		"color": Color(0.2, 0.9, 0.2),
		"ball_color": Color(0.2, 1, 0.2),
		"multiplier": 1.2,
		"special_ability": "score_boost"
	},
	"magnet": {
		"name": "Magnet",
		"display_name": "磁铁人",
		"description": "吸附球更容易",
		"color": Color(0.9, 0.2, 0.9),
		"ball_color": Color(0.9, 0.2, 0.9),
		"multiplier": 1.0,
		"special_ability": "magnet"
	},
	"guardian": {
		"name": "Guardian",
		"display_name": "守护者",
		"description": "额外生命+1",
		"color": Color(0.2, 0.5, 1),
		"ball_color": Color(0.2, 0.5, 1),
		"multiplier": 1.0,
		"special_ability": "extra_life"
	}
}

## 当前选中的角色
var current_character_id: String = "default"

func _ready() -> void:
	print("CharacterSystem: 初始化完成")

## 获取当前角色数据
func get_current_character() -> Dictionary:
	return characters.get(current_character_id, characters["default"])

## 选择角色
func select_character(character_id: String) -> bool:
	if not characters.has(character_id):
		push_error("CharacterSystem: 角色不存在 - ", character_id)
		return false
	
	var old_id = current_character_id
	current_character_id = character_id
	
	if old_id != character_id:
		character_changed.emit(old_id, character_id)
	
	character_selected.emit(character_id)
	print("CharacterSystem: 选择角色 - ", characters[character_id]["display_name"])
	return true

## 获取所有角色列表
func get_all_characters() -> Array:
	return characters.keys()

## 获取角色数据
func get_character_data(character_id: String) -> Dictionary:
	return characters.get(character_id, {})

## 获取角色显示名称
func get_character_display_name(character_id: String) -> String:
	var data = get_character_data(character_id)
	return data.get("display_name", "未知")

## 获取角色描述
func get_character_description(character_id: String) -> String:
	var data = get_character_data(character_id)
	return data.get("description", "")

## 获取角色颜色
func get_character_color(character_id: String) -> Color:
	var data = get_character_data(character_id)
	return data.get("color", Color.WHITE)

## 获取角色球颜色
func get_ball_color(character_id: String) -> Color:
	var data = get_character_data(character_id)
	return data.get("ball_color", Color.RED)

## 获取角色得分倍率
func get_multiplier(character_id: String) -> float:
	var data = get_character_data(character_id)
	return data.get("multiplier", 1.0)

## 应用角色特殊能力
func apply_special_ability(ability_name: String, target: Node) -> void:
	match ability_name:
		"speed_boost":
			if target.has_method("apply_speed_multiplier"):
				target.apply_speed_multiplier(1.2)
		"score_boost":
			if target.has_method("apply_score_multiplier"):
				target.apply_score_multiplier(1.2)
		"magnet":
			if target.has_method("enable_magnet"):
				target.enable_magnet()
		"extra_life":
			if target.has_method("add_life"):
				target.add_life(1)

## 重置为默认角色
func reset_to_default() -> void:
	select_character("default")
