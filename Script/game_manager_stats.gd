extends Resource
class_name GameManagerStats

@export_group("Enemies")
@export var list_enemies: Array[PackedScene] = []
@export var miniboss: PackedScene

@export_group("Round Settings")
@export var round_duration := 60.0
@export var base_spawn_interval := 2.0
@export var spawn_interval_decrease := 0.15
@export var current_round := 1

@export_group("Paths")
@export var player_path: NodePath
@export var hud_path: NodePath

@export_group("Difficulty")
@export var multiplier_per_round := 0.2
