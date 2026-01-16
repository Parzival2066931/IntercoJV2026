extends BaseItem
class_name StatItem

@export_group("Bonus Bruts (+)")
@export var hp: int = 0
@export var hp_regen: int = 0
@export var armor := 0
@export var damage: int = 0
@export var speed: float = 0.0
@export var attack_range: int = 0
@export var luck: int = 0

@export_group("Bonus Pourcentage (%)")
@export_range(-1, 1, 0.01) var hp_percent: float = 0.0
@export_range(-1, 1, 0.01) var damage_percent: float = 0.0
@export_range(-1, 1, 0.01) var speed_percent: float = 0.0
@export_range(-1, 1, 0.01) var attack_speed_percent: float = 0.0

func apply_effect(player: Node2D, game_manager: Node, rarity):
	var stats = player.stats
	
	stats.max_hp += hp
	stats.current_hp += hp
	stats.hp_regen += hp_regen
	stats.armor += armor
	stats.base_damage += damage
	stats.speed += speed
	stats.attack_range += attack_range
	stats.luck += luck
	stats.hp_percent_modifier += hp_percent
	stats.damage_percent_modifier += damage_percent
	stats.speed_percent_modifier += speed_percent
	stats.attack_speed_percent_modifier += attack_speed_percent

	player.update_stats()
