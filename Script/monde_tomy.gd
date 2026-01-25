extends Node2D
class_name Monde

@onready var game_manager: GameManager = $GameManager

@onready var hud: Hud = $HUD
@onready var dimmer := $HUD/Dimmer
@onready var hud_content := $HUD/RoundsControl
@onready var shop := $HUD/Shop
@onready var game_over := $HUD/GameOver
@onready var menu := $HUD/Menu
@onready var settings := $HUD/Settings
@onready var start_ship := $HUD/StartShip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("MONDE PATH=", get_scene_file_path())
	print("MONDE SAVED? (si path vide -> instancié autrement)")

	hud.process_mode = Node.PROCESS_MODE_ALWAYS
	menu.z_index = 100
	start_ship.z_index = 0
	dimmer.z_index = 50

	
	hide_all_ui()
	
	get_tree().paused = false
	
	game_manager.state_changed.connect(_on_state_changed)
	game_manager.new_game.connect(shop.reset_shop)
	
	await get_tree().process_frame
	_on_state_changed(game_manager.state)

func hide_all_ui() -> void:
	dimmer.hide()
	menu.hide()
	shop.hide()
	game_over.hide()
	settings.hide()
	hud_content.hide()

	start_ship.hide()
	start_ship.process_mode = Node.PROCESS_MODE_DISABLED


func _on_state_changed(state: GameManager.GameState) -> void:
	hide_all_ui()

	var should_pause := (state != GameManager.GameState.IN_ROUND)
	get_tree().paused = should_pause
	
	hud_content.visible = (state == GameManager.GameState.IN_ROUND)

	match state:
		GameManager.GameState.SHOP:
			shop.setup()
			dimmer.visible = true
			shop.visible = true
		GameManager.GameState.GAME_OVER:
			dimmer.visible = true
			game_over.visible = true
		GameManager.GameState.MENU:
			print("J'affiche le menu")
			menu.visible = true
		GameManager.GameState.INTRO:
			start_ship.show()
			start_ship.process_mode = Node.PROCESS_MODE_ALWAYS
			var depart := start_ship.get_node("Depart") as AnimatedSprite2D
			var decollage := start_ship.get_node("Decollage") as Sprite2D
			if decollage: decollage.hide()
			if depart:
				depart.show()
				depart.play("Départ")

		GameManager.GameState.IN_ROUND:
			get_tree().paused = false
			hud_content.visible = true
	print("MENU VISIBLE:", menu.visible, " STARTSHIP:", start_ship.visible, " STATE:", state)
