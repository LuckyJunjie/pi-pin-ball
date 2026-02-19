extends Node

## ShopManager.gd - 商店管理系统
## 管理游戏内购和虚拟货币

## 虚拟货币
var coins: int = 0
var gems: int = 0

const SHOP_FILE = "user://shop.dat"

## 商店商品
var shop_items: Dictionary = {
	"characters": {
		"speedy": {"name": "闪电侠", "price": 500, "currency": "coins", "purchased": false},
		"lucky": {"name": "幸运儿", "price": 500, "currency": "coins", "purchased": false},
		"magnet": {"name": "磁铁人", "price": 800, "currency": "coins", "purchased": false},
		"guardian": {"name": "守护者", "price": 1000, "currency": "coins", "purchased": false}
	},
	"powerups": {
		"extra_ball": {"name": "额外球", "price": 100, "currency": "coins"},
		"double_score": {"name": "双倍得分", "price": 200, "currency": "coins"},
		"slow_ball": {"name": "慢速球", "price": 150, "currency": "coins"},
		"shield": {"name": "护盾", "price": 300, "currency": "coins"}
	},
	"cosmetics": {
		"gold_ball": {"name": "金色弹球", "price": 50, "currency": "gems"},
		"rainbow_trail": {"name": "彩虹拖尾", "price": 100, "currency": "gems"},
		"premium_theme": {"name": " Premium主题", "price": 200, "currency": "gems"}
	}
}

func _ready() -> void:
	_load_shop_data()

func _load_shop_data() -> void:
	if FileAccess.file_exists(SHOP_FILE):
		var file = FileAccess.open(SHOP_FILE, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				var data = json.get_data()
				coins = data.get("coins", 0)
				gems = data.get("gems", 0)
				# 更新已购买的商品
				var purchased = data.get("purchased_characters", [])
				for char_id in purchased:
					if shop_items["characters"].has(char_id):
						shop_items["characters"][char_id]["purchased"] = true
			file.close()

func _save_shop_data() -> void:
	var purchased = []
	for char_id in shop_items["characters"].keys():
		if shop_items["characters"][char_id].get("purchased", false):
			purchased.append(char_id)
	
	var data = {
		"coins": coins,
		"gems": gems,
		"purchased_characters": purchased
	}
	
	var file = FileAccess.open(SHOP_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

## 购买商品
func purchase_item(category: String, item_id: String) -> bool:
	if not shop_items.has(category):
		return false
	if not shop_items[category].has(item_id):
		return false
	
	var item = shop_items[category][item_id]
	var currency = item.get("currency", "coins")
	var price = item.get("price", 0)
	
	# 检查货币是否足够
	if currency == "coins" and coins < price:
		return false
	if currency == "gems" and gems < price:
		return false
	
	# 扣除货币
	if currency == "coins":
		coins -= price
	else:
		gems -= price
	
	# 标记为已购买（如果是角色）
	if category == "characters":
		shop_items[category][item_id]["purchased"] = true
	
	_save_shop_data()
	print("ShopManager: 购买成功 - ", item["name"])
	return true

## 添加货币
func add_coins(amount: int) -> void:
	coins += amount
	_save_shop_data()

func add_gems(amount: int) -> void:
	gems += amount
	_save_shop_data()

## 获取货币数量
func get_coins() -> int:
	return coins

func get_gems() -> int:
	return gems

## 获取商品列表
func get_items(category: String) -> Dictionary:
	return shop_items.get(category, {})

func is_purchased(category: String, item_id: String) -> bool:
	if shop_items.has(category) and shop_items[category].has(item_id):
		return shop_items[category][item_id].get("purchased", false)
	return false
