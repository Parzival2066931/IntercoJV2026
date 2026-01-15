extends Resource
class_name PlayerStats

@export_group("Other")
@export var current_hp: float = 100.0

@export_group("Base Stats")
@export var max_hp: float = 100.0
@export var hp_regen: float = 0.0
@export var armor: int = 0
@export var base_damage: float = 0.0
@export var speed: float = 1000.0
@export var penetration: int = 0
@export var attack_range: float = 0.0
@export var luck: int = 0

@export_group("Modifiers (%)")
@export var hp_percent_modifier: float = 0.0
@export var damage_percent_modifier: float = 0.0
@export var speed_percent_modifier: float = 0.0
@export var attack_speed_percent_modifier: float = 0.0

func get_total_max_hp() -> float:
	return max_hp * (1.0 + hp_percent_modifier)

func get_total_damage(weapon_base_damage: float) -> float:
	return (weapon_base_damage + base_damage) * (1.0 + damage_percent_modifier)

func get_total_speed() -> float:
	return speed * (1.0 + speed_percent_modifier)

func change_hp(amount: float):
	current_hp = clamp(current_hp + amount, 0, get_total_max_hp())
