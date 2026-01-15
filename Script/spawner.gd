extends Node2D
class_name Spawner

signal loot_spawned(objet_instance)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
func spawn(objet: PackedScene, pos: Vector2) -> Node:
	var objet_a_spawn = objet.instantiate()
	objet_a_spawn.global_position = pos
	get_parent().call_deferred("add_child", objet_a_spawn)
	loot_spawned.emit(objet_a_spawn)
	return objet_a_spawn
