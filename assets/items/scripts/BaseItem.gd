extends Resource
class_name BaseItem

enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, ALL }

@export var name: String
@export var price: int
@export var icon: Texture2D
@export var rarity: Rarity = Rarity.COMMON
@export var description : String
@export var modulate_color : Color = "ffffff"


func apply_effect(player: Node2D, game_manager: Node, rarity):
	pass
