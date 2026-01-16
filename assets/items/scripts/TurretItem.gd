extends BaseItem
class_name TurretItem

@export var turret_stats : TurretStats

func apply_effect(player: Node2D, game_manager: Node):
	var turret_manager = player.get_node("WeaponManager")
	if turret_manager.has_method("add_turret"): # and turret_manager.turret_count < turret_manager.max_weapon
		turret_manager.add_turret(turret_stats)
	
	player.update_stats()
