extends BaseItem
class_name TurretItem

@export var turret_stats : TurretStats

func apply_effect(player: Node2D, game_manager: Node, rarity):
	var turret_manager = player.get_node("TurretManager")
	
	if turret_manager == null:
		return
	
	var idx = turret_manager.modify_turret(turret_stats)
	if idx >= 0:
		turret_manager.change_color(rarity, idx)

	player.update_stats()
