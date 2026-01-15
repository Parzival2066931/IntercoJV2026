extends Control
class_name GameOver
	
@export var gm_path: NodePath
@onready var gm: GameManager = get_node_or_null(gm_path) as GameManager

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	mouse_filter = Control.MOUSE_FILTER_STOP

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	gm.reset_game()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
