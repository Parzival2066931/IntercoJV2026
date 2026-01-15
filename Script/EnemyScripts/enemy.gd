extends CharacterBody2D
class_name Enemy

var player : Player


@export var min_dist := 180.0
@export var max_dist := 260.0
@export var loot: PackedScene
@export var base_speed := 180.0
@export var base_damage := 1.0
@export var base_max_hp := 30.0

@onready var health_bar := $Health

var speed: float
var hp : float
var max_hp: float
var damage: float
var is_dying = false


signal enemy_died
signal object_in_area


func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
	#loot = preload("res://scenes/coin2.tscn")
	max_hp = base_max_hp
	damage = base_damage
	hp = max_hp
	object_in_area.connect(on_object_detected_in_area)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if player == null:
		print("Player null")
		return

	var to_player = player.global_position - global_position
	var dist = to_player.length()
	var dir_to_player = to_player.normalized()

	var move_dir := Vector2.ZERO

	if dist > max_dist:
		move_dir = dir_to_player
	elif dist < min_dist:
		move_dir = -dir_to_player
	else:
		move_dir = Vector2.ZERO
		
	look_at(player.global_position)

	velocity = move_dir * speed
	move_and_slide()
	

func set_difficulty(mult: float):
	max_hp = base_max_hp * mult
	damage = base_damage * mult
	speed = base_speed * mult
	hp = max_hp
	health_bar.max_value = max_hp
	health_bar.value = hp
	
func take_damage(dam: float):
	if is_dying:
		return
	hp -= dam
	health_bar.value = hp
	if (hp <= 0):
		is_dying = true
		die()

func die():
	enemy_died.emit(loot, global_position)
	queue_free()

func on_object_detected_in_area(body: Node2D) -> void:
	if not $AttackCooldown.is_stopped():
		return
	if body.has_method("is_attacked"):
		$AttackCooldown.start()
		body.is_attacked(damage)
