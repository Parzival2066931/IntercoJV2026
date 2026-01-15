extends Node2D


@export var range: float
@export var speed: float
@export var damage: float

var canons: Array[Node]

var bullet:= preload("res://Scenes/base_bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canons = get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func shoot():
	for canon in canons:
		var new_bullet = bullet.instantiate()
		new_bullet.global_position = canon.global_position
		new_bullet.global_rotation = canon.global_rotation
		new_bullet.setup(speed, damage, range)
		new_bullet.set_collision_layer_value(1, true)
		new_bullet.set_collision_mask_value(1, true)
		new_bullet.set_collision_mask_value(2, true)
		new_bullet.set_collision_mask_value(4, true)

		get_tree().current_scene.add_child(new_bullet)
