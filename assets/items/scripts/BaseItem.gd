extends Resource
class_name BaseItem

enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

@export var name: String
@export var price: int
@export var icon: Texture2D
@export var rarity: Rarity = Rarity.COMMON
@export var description : String
@export_range(0, 100, 1) var max_count := 0

func apply_effect(player: Node2D, game_manager: Node):
	pass
