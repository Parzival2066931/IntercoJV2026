extends SpecialItem
class_name SuspiciousDrink

func apply_effect(player: Node2D, game_manager: Node, rarity):
	if randi() % 2:
		player.scale *= 2
		player.get_node("Trail2D").width *= 2
		player.get_node("Trail2D").length *= 2
	else:
		player.scale *= 0.5
		player.get_node("Trail2D").width *= 0.5
		player.get_node("Trail2D").length *= 0.5
	
	player.scale_changed.emit()
	
	
