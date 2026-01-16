extends Node2D
class_name TurretManager

const turret_scene = preload("res://Scenes/turret.tscn")
const baller_scene = preload("res://Scenes/baller_turret.tscn")

@export var starting_turret : TurretStats

var turrets : Array[Turret]

var turret_count = 0
var max_turret := 0

var player
var turrets_positions

func _ready() -> void:
	player = get_parent()
	turrets_positions = player.get_node("TurretsPositions")
	turrets.resize(5)
	add_turret(starting_turret, 2)
	add_new_turret(starting_turret)
	add_new_turret(starting_turret)
	add_new_turret(starting_turret)
	add_new_turret(starting_turret)
	
func add_new_turret(turret_stats : TurretStats):
	add_turret(turret_stats, get_first_empty_turret())

func add_turret(turret_stats : TurretStats, index : int):
	if index < 0:
		print("Plus de place pour les tourelles")
		return
		
	var path = turret_stats.resource_path
	var file_name = path.get_file()
	var new_turret
	if file_name == "baller_turret.tres":
		new_turret = baller_scene.instantiate()
	else:
		new_turret = turret_scene.instantiate()
		
	new_turret.turret_stats = turret_stats
	new_turret.position = turrets_positions.get_children()[index].position
	add_child(new_turret)
	turrets[index] = new_turret
	turret_count += 1
	
func get_first_empty_turret() -> int:
	for i in range(turrets.size()):
		if turrets[i] == null:
			return i
	return -1
	
func get_turrets() -> Array[Node]:
	return get_children()

#ajouter modify_turrets(turret: Turret, index: int):
