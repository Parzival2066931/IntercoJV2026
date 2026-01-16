extends SpecialItem
class_name cosmic_card

@export var interest :=1.2

func _execute_logic(player: Node2D , game_manager : Node):
	game_manager.on_cash_changed(int(floor(game_manager.amount_of_stars *(interest - 1.0))))
	
