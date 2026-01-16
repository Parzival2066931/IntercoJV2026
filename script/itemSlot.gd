extends Node

@onready var item_texture: TextureRect = $ItemTexture
@onready var item_number: Label = $ItemTexture/ItemNumber

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup(item: BaseItem, count: int): 
	$ItemTexture.texture = item.icon
	$ItemTexture/ItemNumber.text = "x%d" % count
