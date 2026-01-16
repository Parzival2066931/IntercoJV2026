extends BaseItem
class_name SpecialItem

enum Trigger { ONCE, ON_WAVE_START, ON_WAVE_END, ON_KILL, ON_PLAYER_DYING, ON_LEVEL_UP, ON_COIN_PICKED}
@export var trigger_type: Trigger

func apply_effect(player: Node2D, game_manager: Node):
	print("1")
	match trigger_type:
		Trigger.ONCE:
			_execute_logic(player, game_manager)
		Trigger.ON_WAVE_END:
			game_manager.wave_end.connect(_execute_logic.bind(player, game_manager))
		Trigger.ON_WAVE_START:
			print("2")
			game_manager.wave_start.connect(_execute_logic.bind(player, game_manager))
		Trigger.ON_KILL:
			pass

func _execute_logic(player: Node2D, game_manager : Node):
	pass
