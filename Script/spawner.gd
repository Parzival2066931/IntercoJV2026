extends Node2D
class_name Spawner

signal loot_spawned(objet_instance)

@export var meteor_scene: PackedScene
@export var canvas_layer_path: NodePath
@onready var canvas_layer := get_node(canvas_layer_path)



var zone_min := Vector2(3000, -1875)
var zone_max := Vector2(7359, -5500)

var _meteor_task_running := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preload("res://Script/star.gd")

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
	
func spawn_ship(objet: PackedScene, pos: Vector2) -> Node:
	var objet_a_spawn = objet.instantiate()
	objet_a_spawn.global_position = pos
	canvas_layer.call_deferred("add_child", objet_a_spawn)
	return objet_a_spawn
	
func spawn(objet: PackedScene, pos: Vector2) -> Node:
	print(objet)
	var objet_a_spawn = objet.instantiate()
	objet_a_spawn.global_position = pos
	get_parent().call_deferred("add_child", objet_a_spawn)
	loot_spawned.emit(objet_a_spawn)
	return objet_a_spawn
	
func start_meteor_shower() -> void:
	var p := Vector2(
		randf_range(zone_min.x, zone_max.x),
		randf_range(zone_min.y, zone_max.y)
	)
	
	var meteor = spawn(meteor_scene, p)
	var dir := Vector2(-1, 1)
	meteor.setup(dir)



	
