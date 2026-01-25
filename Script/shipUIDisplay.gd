extends Node


@onready var texture_rect: TextureRect = $TextureRect
@onready var weapon_texture_1: TextureRect = $Control/weaponTexture1
@onready var weapon_texture_2: TextureRect = $Control/weaponTexture2
@onready var weapon_texture_3: TextureRect = $Control/weaponTexture3
@onready var weapon_texture_4: TextureRect = $Control/weaponTexture4
@onready var weapon_texture_5: TextureRect = $Control/weaponTexture5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _updateUIShipSprite():
	pass
