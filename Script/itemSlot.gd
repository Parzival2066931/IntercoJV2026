extends Node

#@onready var item_texture: TextureRect = $ItemTexture
#@onready var item_number: Label = $ItemTexture/ItemNumber

func setup(item: BaseItem, count: int): 
	$ItemTexture.texture = item.icon
	$ItemTexture/ItemNumber.text = "x%d" % count
	$ItemTexture.self_modulate = item.modulate_color
	print(item.modulate_color)
