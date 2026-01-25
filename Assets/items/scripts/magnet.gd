extends SpecialItem
class_name Magnet


@export var scale_range := Vector2(1.2, 1.2)

func _execute_logic(player: Node2D, game_manager : Node):
	player.get_node("AttractionField").scale += scale_range
