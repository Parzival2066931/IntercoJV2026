extends CharacterBody2D
class_name Player


signal player_died
signal hp_changed
signal scale_changed

@export var base_stats: PlayerStats
var stats: PlayerStats

@export var base_time := 2.0
@export var acceleration := 0.1

@onready var trail_2d: Line2D = $Trail2D



var direction := Vector2()
var hp: float
var facing := "front"

func _ready():
	if base_stats:
		stats = base_stats.duplicate()
		stats.current_hp = stats.get_total_max_hp()
		emit_signal("hp_changed", stats.current_hp, stats.get_total_max_hp())
	print("Player ready")
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	direction = direction.normalized()
	
	if (direction.length() > 0 ):
		velocity = velocity.lerp(direction * stats.get_total_speed(), acceleration)

	move_and_slide()

func take_damage(damage: float):
	is_attacked(damage)

func is_attacked(damage: float):
	print(damage)
	print("AÎE")
	print(stats.current_hp)
	stats.current_hp -= damage * (15.0 / (stats.armor + 15.0))
	print(stats.current_hp)
	hp_changed.emit(stats.current_hp, stats.get_total_max_hp())
	if stats.current_hp <= 0:
		player_died.emit()

func _on_passive_heal_timeout() -> void:
	if stats.current_hp < stats.get_total_max_hp():
		stats.current_hp += 1
		if stats.current_hp > stats.get_total_max_hp():
			stats.current_hp = stats.get_total_max_hp()
		hp_changed.emit(stats.current_hp, stats.get_total_max_hp())

func update_stats():
	hp_changed.emit(stats.current_hp, stats.get_total_max_hp())
	$PassiveHeal.wait_time = base_time * (pow(0.95, min(stats.hp_regen, 100)))
	for turret in get_turrets():
		turret.stats.damage = stats.get_total_damage(turret.turret_stats.damage)
		turret.stats.attack_range = turret.turret_stats.attack_range + stats.attack_range
		turret.stats.fire_rate = turret.turret_stats.fire_rate / (1.0 + stats.attack_speed_percent_modifier)

func get_turrets():
	return $TurretManager.get_children()

func setup():
	if base_stats:
		stats = base_stats.duplicate()
		stats.current_hp = stats.get_total_max_hp()
	scale = Vector2(1.0, 1.0)
	velocity = Vector2.ZERO
	global_position = Vector2.ZERO
	trail_2d.reset_trail()
	$TP_Timer.start()
	trail_2d.hide()
	print("Player ready")
	emit_signal("hp_changed", stats.current_hp, stats.get_total_max_hp())


func _on_tp_timer_timeout() -> void:
	trail_2d.clear_points()
	trail_2d.show()
