extends BaseItem
class_name TurretItem

enum ItemType { WEAPON, BULLET }

@export var type: ItemType = ItemType.WEAPON
@export var weapon_stats : TurretStats
@export var bullet_scene : PackedScene

func apply_effect(player: Node2D, game_manager: Node):
	var weapon_manager = player.get_node("WeaponManager")
	if type == ItemType.WEAPON:
		if weapon_manager.has_method("add_weapon") and weapon_manager.weapon_count < weapon_manager.max_weapon:
			weapon_manager.add_weapon(weapon_stats)
	
	elif type == ItemType.BULLET:
		if player.has_method("change_bullet"):
			player.change_bullet(bullet_scene)
	
	player.update_stats()
			
	print("Effet appliqué : ", ItemType.keys()[type])
