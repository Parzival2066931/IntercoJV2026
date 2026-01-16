extends Node2D
class_name GameManager

@export var settings: GameManagerStats
var stats: GameManagerStats

enum GameState {
	MENU,
	IN_ROUND,
	SHOP,
	GAME_OVER
}
var state := GameState.MENU
signal state_changed

signal wave_start
signal wave_end

@onready var round_timer := $Round_Timer
@onready var spawn_timer := $Spawn_Timer
@onready var spawner := $Spawner
@onready var star_collected := $StarCollected
@export var decollage_path: NodePath

@export var min_delay := 0.1
@export var max_delay := 0.5

var list_enemies: Array[PackedScene]
var monster_egg: PackedScene
var round_duration: float
var base_spawn_interval: float
var spawn_interval_decrease: float
var current_round: int
var player_path: NodePath
var hud_path: NodePath
var multiplier_per_round: float
var player: Player
var hud: Hud
var decollage: Sprite2D

var amount_of_star = 0
var time_left: float
var zone_min := Vector2(-3000, -1875)
var zone_max := Vector2(3000, 1870)

var owned_items: Array[BaseItem] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("GameManager ready")
	
	if settings == null:
		print("setting est null")
		push_error("GameManager: settings est NULL. Assigne un GameManagerStats (.tres) dans l'inspecteur.")
		return
		
	stats = settings.duplicate()
	list_enemies = stats.list_enemies
	monster_egg = stats.miniboss
	round_duration = stats.round_duration
	base_spawn_interval = stats.base_spawn_interval
	spawn_interval_decrease = stats.spawn_interval_decrease
	current_round = stats.current_round
	player_path = stats.player_path
	hud_path = stats.hud_path
	multiplier_per_round = stats.multiplier_per_round
	
	player = get_node_or_null(stats.player_path) as Player
	hud = get_node_or_null(stats.hud_path) as Hud
	decollage = get_node_or_null(decollage_path)
	
	if player == null:
		print("Player est null")
		push_error("GameManager: Player introuvable. Assigne player_path.")
		return
	if hud == null:
		print("Hud est null")
		push_error("GameManager: HUD introuvable. Assigne hud_path.")
		return
	
	set_state(GameState.MENU)
	
	player.hp_changed.connect(on_player_hp_changed)
	player.player_died.connect(on_game_over)
	
	spawner.loot_spawned.connect(on_loot_spawned)
	hud.spawn_ship_request.connect(on_launching_ship)
	
	hud.set_hp(player.stats.current_hp, player.stats.max_hp)
	hud.set_cash(amount_of_star)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if round_timer.is_stopped():
		return
	hud.set_time_left(round_timer.time_left)
	time_left = max(0.0, round_timer.time_left)

func set_state(new_state: GameState) -> void:
	if state == new_state:
		return
	state = new_state
	state_changed.emit(state)
	

func reset_game():
	round_timer.stop()
	spawn_timer.stop()
	
	owned_items.clear()
	amount_of_star = 0
	current_round = 1
	multiplier_per_round = 1.0
	time_left = 0.0
	
	hud.set_cash(amount_of_star)
	hud.set_round(current_round)
	hud.set_time_left(0)
	
	player.setup()
	hud.set_hp(player.stats.current_hp, player.stats.max_hp)
	
	var turret_manager := player.get_node_or_null("TurretManager")
	if turret_manager:
		turret_manager.reset_to_starting()
	owned_items = []
		
	#ajouter les player_stats quand ce sera fait
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	for loot in get_tree().get_nodes_in_group("loots"):
		loot.queue_free()
	for meteor in get_tree().get_nodes_in_group("meteors"):
		meteor.queue_free()
	for item in owned_items:
		print(item)
		owned_items.clear()
		
	decollage.hide()
	
	set_state(GameState.IN_ROUND)

func start_round():
	print("=== VAGUE", current_round, "===")
	$MusicPlayer.main_theme()
	wave_start.emit()
	
	hud.set_round(current_round)
	multiplier_per_round = get_round_multiplier(current_round)
	print("Enemies are stronger")
	print("Diff: ", multiplier_per_round)
	if current_round == 11:
		list_enemies.append(preload("res://scenes/EnemyScenes/kamikaze.tscn"))
	
	if current_round % 5 == 0 && current_round != 0 && current_round != 20:
		start_mini_boss_round()
	else:
		var interval = max(0.4, base_spawn_interval - (current_round - 1) * spawn_interval_decrease)
		spawn_timer.wait_time = interval
		spawn_timer.start()
		
	round_timer.wait_time = round_duration
	round_timer.start()
	hud.set_time_left(round_timer.time_left)

func start_mini_boss_round():
	var easter_egg = spawner.spawn(monster_egg, get_random_position())
	easter_egg.easter_egg_found.connect(on_easter_egg_found)
	spawn_timer.wait_time = randf_range(min_delay, max_delay)
	spawn_timer.start()

func on_easter_egg_found(base_loot: int):
	on_cash_changed(base_loot * current_round / 5)

func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var angle := randf() * TAU
	var r := sqrt(randf()) * radius
	return center + Vector2(cos(angle), sin(angle)) * r

func on_mini_boss_died(loots: Array[PackedScene], center: Vector2, radius: float):
	for loot in loots:
		spawner.spawn(loot, random_point_in_circle(center, radius))
	end_round()

func on_enemy_died(loot, pos):
	spawner.spawn(loot, pos)

func on_game_over():
	print("Vous êtes mort")
	set_state(GameState.GAME_OVER)

func on_loot_spawned(instance: Node):
	if instance.is_in_group("loots"):
		if not instance.star_collected.is_connected(on_cash_changed):
			instance.star_collected.connect(on_cash_changed)

func on_cash_changed(amount: int):
	amount_of_star += amount
	hud.set_cash(amount_of_star)
	if amount > 0:
		star_collected.pitch_scale = randf_range(0.8, 1.2)
		star_collected.play()

func on_launching_ship(pos: Vector2, ship: PackedScene):
	var star_ship = spawner.spawn_ship(ship, pos)
	star_ship.z_index = 2
	star_ship.start_game_request.connect(reset_game)

func get_random_position() -> Vector2:
	var random_x = randf_range(zone_min.x, zone_max.x)
	var random_y = randf_range(zone_min.y, zone_max.y)
	return Vector2(random_x, random_y)

func spawn_new_enemy():
	var new_enemy = list_enemies.pick_random()
	var enemy: Enemy = spawner.spawn(new_enemy, get_random_position())
	enemy.enemy_died.connect(on_enemy_died)
	enemy.call_deferred("set_difficulty", multiplier_per_round)

func get_round_multiplier(cur_round: int) -> float:
	return pow(1.2, (cur_round - 1))

func _on_round_timer_timeout() -> void:
	end_round()

func _on_spawn_timer_timeout() -> void:
	if current_round % 5 == 0 && current_round != 0 && current_round != 20:
		spawner.start_meteor_shower()
	else:
		spawn_new_enemy()

func on_player_hp_changed(hp: float, max_hp: float) -> void:
	pass
	hud.set_hp(hp, max_hp)

func end_round():
	$MusicPlayer.shop_theme()
	print("Je change de musique")
	wave_end.emit()
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	for meteor in get_tree().get_nodes_in_group("meteors"):
		meteor.queue_free()
	
	spawn_timer.stop()
	
	set_state(GameState.SHOP)
	current_round += 1
