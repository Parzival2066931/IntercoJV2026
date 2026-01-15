extends Control
class_name Menu


@export var gm_path: NodePath

@onready var game_manager := get_node_or_null(gm_path)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	



func _on_play_pressed() -> void:
	game_manager.set_state(game_manager.GameState.IN_ROUND)

func _on_settings_pressed() -> void:
	pass # Replace with function body.
	
func _on_leave_pressed() -> void:
	get_tree().quit()
