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

# enum Trigger { ONCE, ON_WAVE_START, ON_WAVE_END, ON_KILL, ON_PLAYER_DYING, ON_LEVEL_UP, ON_COIN_PICKED}

signal wave_start
signal wave_end

@onready var round_timer := $Round_Timer
@onready var spawn_timer := $Spawn_Timer
@onready var spawner := $Spawner
@onready var coin_collected := $CoinCollected
@onready var coin_stealed := $CoinStealed


var list_enemies: Array[PackedScene]
var mini_boss: PackedScene
var round_duration: float
var base_spawn_interval: float
var spawn_interval_decrease: float
var current_round: int
var player_path: NodePath
var hud_path: NodePath
var multiplier_per_round: float
var player: Player
#ar hud: Hud

var amount_of_coin = 0
var time_left: float
var zone_min := Vector2(-1824, -1050)
var zone_max := Vector2(2475, 1944)

#var owned_items: Array[BaseItem] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("GameManager ready")
	
	if settings == null:
		print("setting est null")
		push_error("GameManager: settings est NULL. Assigne un GameManagerStats (.tres) dans l'inspecteur.")
		return
		
	stats = settings.duplicate()
	list_enemies = stats.list_enemies
	mini_boss = stats.miniboss
	round_duration = stats.round_duration
	base_spawn_interval = stats.base_spawn_interval
	spawn_interval_decrease = stats.spawn_interval_decrease
	current_round = stats.current_round
	player_path = stats.player_path
	hud_path = stats.hud_path
	multiplier_per_round = stats.multiplier_per_round
	
	player = get_node_or_null(settings.player_path) as Player
	#hud = get_node_or_null(settings.hud_path) as Hud
	
	if player == null:
		print("Player est null")
		push_error("GameManager: Player introuvable. Assigne player_path.")
		return
	#if hud == null:
	#	print("Hud est null")
	#	push_error("GameManager: HUD introuvable. Assigne hud_path.")
	#	return
	
	set_state(GameState.MENU)
	
	#player.hp_changed.connect(on_player_hp_changed)
	player.player_died.connect(on_game_over)
	
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy.name == "MiniBoss":
			enemy.boss_died.connect(on_mini_boss_died)
		else:
			if enemy.name == "FastStealerEnemy":
				enemy.stealing_money.connect(on_money_steal)
			enemy.enemy_died.connect(on_enemy_died)
	spawner.loot_spawned.connect(on_loot_spawned)
	
	#hud.set_hp(player.stats.current_hp, player.stats.max_hp)
	#hud.set_cash(amount_of_coin)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if round_timer.is_stopped():
		return
	#hud.set_time_left(round_timer.time_left)
	time_left = max(0.0, round_timer.time_left)

func set_state(new_state: GameState) -> void:
	if state == new_state:
		return
	state = new_state
	state_changed.emit(state)
	

func reset_game():
	stats = settings.duplicate()
	list_enemies = stats.list_enemies
	mini_boss = stats.miniboss
	round_duration = stats.round_duration
	base_spawn_interval = stats.base_spawn_interval
	spawn_interval_decrease = stats.spawn_interval_decrease
	current_round = stats.current_round
	player_path = stats.player_path
	hud_path = stats.hud_path
	multiplier_per_round = stats.multiplier_per_round
	player.setup()
	#ajouter les player_stats quand ce sera fait
	
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.queue_free()
	for loot in get_tree().get_nodes_in_group("Loots"):
		loot.queue_free()
	
	set_state(GameState.IN_ROUND)

func start_round():
	print("=== ROUND", current_round, "===")
	$MusicPlayer.main_theme()
	wave_start.emit()
	
	#hud.set_round(current_round)
	multiplier_per_round = get_round_multiplier(current_round)
	print("Enemies are stronger")
	print("Diff: ", multiplier_per_round)
	match current_round:
	#	6:
	#		list_enemies.append(preload("res://scenes/EnemyScenes/fast_stealer_enemy.tscn"))
	#	11:
	#		list_enemies.append(preload("res://scenes/EnemyScenes/kamikaze.tscn"))
	#	16:
			#potentiellement un 4e type d'ennemi
			pass
	
	if current_round % 5 == 0 && current_round != 0:
		start_mini_boss_round()
	else:
		round_timer.wait_time = round_duration
		round_timer.start()
	#	hud.set_time_left(round_timer.time_left)
	
		var interval = max(0.4, base_spawn_interval - (current_round - 1) * spawn_interval_decrease)
		spawn_timer.wait_time = interval
		spawn_timer.start()

func start_mini_boss_round():
	round_timer.stop()
	#hud.hide_timer()
	var boss = spawner.spawn(mini_boss, get_random_position())
	boss.player = player
	boss.stomp_impact.connect(player.on_stomp_impact)
	print("Camera connecté")
	boss.stomp_spawn_request.connect(on_boss_stomp_spawn_request)
	#boss.set_difficulty(multiplier_per_round)
	boss.call_deferred("set_difficulty", multiplier_per_round)
	boss.boss_died.connect(on_mini_boss_died)

func random_point_in_circle(center: Vector2, radius: float) -> Vector2:
	var angle := randf() * TAU
	var r := sqrt(randf()) * radius
	return center + Vector2(cos(angle), sin(angle)) * r

func on_boss_stomp_spawn_request(center: Vector2, radius: float):
	var count_enemies = 4 + randi() % 2
	for i in range(count_enemies):
		var new_enemy = list_enemies.pick_random()
		var enemy = spawner.spawn(new_enemy, random_point_in_circle(center, radius))
		enemy.enemy_died.connect(on_enemy_died)
		enemy.set_difficulty(multiplier_per_round)

func on_mini_boss_died(loots: Array[PackedScene], center: Vector2, radius: float):
	for loot in loots:
		spawner.spawn(loot, random_point_in_circle(center, radius))
	end_round()

func on_enemy_died(loot, pos):
	spawner.spawn(loot, pos)

func on_money_steal(amount: int):
	amount_of_coin = max(amount_of_coin - amount, 0)
	#hud.set_cash(amount_of_coin)
	coin_stealed.play()

func on_game_over():
	print("Vous êtes mort")
	set_state(GameState.GAME_OVER)

func on_loot_spawned(instance: Node):
	if instance.is_in_group("Loots"):
		if not instance.coin_collected.is_connected(on_cash_changed):
			instance.coin_collected.connect(on_cash_changed)

func on_cash_changed(amount: int):
	amount_of_coin += amount
	#hud.set_cash(amount_of_coin)
	if amount > 0:
		coin_collected.pitch_scale = randf_range(0.8, 1.2)
		coin_collected.play()

func get_random_position() -> Vector2:
	var random_x = randf_range(zone_min.x, zone_max.x)
	var random_y = randf_range(zone_min.y, zone_max.y)
	return Vector2(random_x, random_y)

#func spawn_new_enemy():
	#var new_enemy = list_enemies.pick_random()
	#var enemy: Enemy = spawner.spawn(new_enemy, get_random_position())
	#enemy.enemy_died.connect(on_enemy_died)
	#print(enemy.name)
	#if enemy.name == "FastStealerEnemy":
		#print("Je vais te voler")
		#enemy.stealing_money.connect(on_money_steal)
	#enemy.call_deferred("set_difficulty", multiplier_per_round)

func get_round_multiplier(cur_round: int) -> float:
	return pow(1.2, (cur_round - 1))

func _on_round_timer_timeout() -> void:
	end_round()

#func _on_spawn_timer_timeout() -> void:
	#spawn_new_enemy()

#func on_player_hp_changed(hp: float, max_hp: float) -> void:
#	hud.set_hp(hp, max_hp)
#	var heal_label: PackedScene = preload("res://scenes/heal_label.tscn")
#	$Spawner.spawn(heal_label, player.global_position + Vector2(0, -100))

func end_round():
	wave_end.emit()
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.queue_free()
	
	spawn_timer.stop()
	
	$MusicPlayer.shop_theme()
	set_state(GameState.SHOP)
	current_round += 1
