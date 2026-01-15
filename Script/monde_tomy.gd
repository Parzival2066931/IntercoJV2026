extends Node2D
class_name Monde



@onready var game_manager: GameManager = $GameManager

@onready var hud: Hud = $HUD
@onready var dimmer := $HUD/Dimmer
@onready var hud_content := $HUD/RoundsControl
#@onready var shop := $HUD/ShopOverlay
@onready var game_over := $HUD/GameOver
@onready var menu := $HUD/Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.process_mode = Node.PROCESS_MODE_ALWAYS
	game_manager.state_changed.connect(_on_state_changed)
	_on_state_changed(game_manager.state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
func _on_state_changed(state: GameManager.GameState) -> void:
	dimmer.visible = false
	#shop.visible = false
	game_over.visible = false
	menu.visible = false
	

	var should_pause := (state == GameManager.GameState.SHOP or state == GameManager.GameState.GAME_OVER)
	get_tree().paused = should_pause
	
	hud_content.visible = (state == GameManager.GameState.IN_ROUND)

	match state:
		GameManager.GameState.SHOP:
			#shop.setup()
			dimmer.visible = true
			#shop.visible = true
		GameManager.GameState.GAME_OVER:
			dimmer.visible = true
			game_over.visible = true
		GameManager.GameState.MENU:
			print("J'affiche le menu")
			menu.visible = true
		GameManager.GameState.IN_ROUND:
			game_manager.start_round()
