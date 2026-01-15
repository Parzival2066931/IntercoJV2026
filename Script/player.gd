extends CharacterBody2D
class_name Player


signal player_died
signal hp_changed

@export var base_stats: PlayerStats
var stats: PlayerStats

@export var base_time := 2.0
@export var acceleration := 0.1

var direction := Vector2()
var hp: float
var facing := "front"

func _ready():
	if base_stats:
		stats = base_stats.duplicate()
		stats.current_hp = stats.get_total_max_hp()
	print("Player ready")
	stats.current_hp = stats.max_hp
	emit_signal("hp_changed", stats.current_hp, stats.max_hp)
	
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	direction = direction.normalized()
	
	if (direction.length() > 0 ):
		velocity = velocity.lerp(direction * stats.get_total_speed(), acceleration)

		
	move_and_slide()
	
	
func update_direction(vec: Vector2):
		# vec peut être dir normalisé ou (target - pos)
	if abs(vec.x) > abs(vec.y):
		facing = "right" if vec.x > 0 else "left"
	else:
		# y positif = bas (front), y négatif = haut (back)
		facing = "front" if vec.y >= 0 else "back"
		
func is_attacked(damage: float):
	stats.current_hp -= damage * (15.0 / (stats.armor + 15))
	hp_changed.emit(stats.current_hp, stats.max_hp)
	if stats.current_hp <= 0:
		player_died.emit()
		
func _on_passive_heal_timeout() -> void:
	if stats.current_hp < stats.max_hp:
		stats.current_hp += 1
		if stats.current_hp > stats.max_hp:
			stats.current_hp = stats.max_hp
		hp_changed.emit(stats.current_hp, stats.max_hp)
		
func update_stats():
	hp_changed.emit(stats.current_hp, stats.max_hp)
	$PassiveHeal.wait_time = base_time * (pow(0.95, min(stats.hp_regen, 100)))
	for weapon in get_weapons():
		weapon.stats.damage = stats.get_total_damage(weapon.weapon_stats.damage)
		weapon.stats.penetration = weapon.weapon_stats.penetration + stats.penetration
		weapon.stats.attack_range = weapon.weapon_stats.attack_range + stats.attack_range
		
func get_weapons():
	return $WeaponManager.get_children()

func setup():
	if base_stats:
		stats = base_stats.duplicate()
		stats.current_hp = stats.get_total_max_hp()
	print("Player ready")
	emit_signal("hp_changed", stats.current_hp, stats.max_hp)
