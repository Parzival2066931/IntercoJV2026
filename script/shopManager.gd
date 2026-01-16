extends Node

@export var gm_path: NodePath
@export var rounds_path: NodePath
@export var cash_path: NodePath
@export var reroll_path: NodePath
@export var ship_ui_display: NodePath
@export var stats_display: NodePath

@export_group("Items_paths")
@export var item1_path: NodePath
@export var item2_path: NodePath
@export var item3_path: NodePath

@onready var game_manager := get_node_or_null(gm_path)
@onready var rounds := get_node_or_null(rounds_path)
@onready var cash := get_node_or_null(cash_path)
@onready var reroll_button := get_node_or_null(reroll_path)
@onready var item_cards := [get_node_or_null(item1_path), get_node_or_null(item2_path), get_node_or_null(item3_path)]
@onready var next_round :=$PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Header/NextRound
@onready var ship_uid:=  get_node_or_null(ship_ui_display)
@onready var stats_panel = get_node_or_null(stats_display)

var player : Player

var attemps: int
var base_attemps := 3
var items = {
	BaseItem.Rarity.COMMON: [],
	BaseItem.Rarity.UNCOMMON: [],
	BaseItem.Rarity.RARE: [],
	BaseItem.Rarity.EPIC: [],
	BaseItem.Rarity.LEGENDARY: []
}

var gm: GameManager

func _ready() -> void:
	print("SHOP ready")
	await get_tree().process_frame
	player = get_tree().current_scene.get_node_or_null("Player")
	if player == null:
		push_error("ShopOverlay: Player introuvable")
	stats_panel.bind_player(player)
	load_all_items()
	for card in item_cards:
		card.item_bought.connect(on_item_bought)
	setup()
	
	
	
func load_all_items():
	var dir := DirAccess.open("res://Assets/items/resources/")
	if dir == null:
		print("OUPS")
		push_error("Impossible d’ouvrir le dossier des items")
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tres"):
			var path := "res://Assets/items/resources/" + file_name
			var res := load(path)

			if res == null:
				print("OUPS2")
				push_warning("Item non chargé : " + path)
				return
			elif res is BaseItem:
				if res.icon == null:
					print("OUPS3")
					push_warning("Item sans icône : " + res.name)
					return
				
				match res.rarity:
					BaseItem.Rarity.COMMON:
						items[BaseItem.Rarity.COMMON].append(res)
					BaseItem.Rarity.UNCOMMON:
						items[BaseItem.Rarity.UNCOMMON].append(res)
					BaseItem.Rarity.RARE:
						items[BaseItem.Rarity.RARE].append(res)
					BaseItem.Rarity.EPIC:
						items[BaseItem.Rarity.EPIC].append(res)
					BaseItem.Rarity.LEGENDARY:
						items[BaseItem.Rarity.LEGENDARY].append(res)
					BaseItem.Rarity.ALL:
						items[BaseItem.Rarity.COMMON].append(res.duplicate())
						items[BaseItem.Rarity.UNCOMMON].append(res.duplicate())
						items[BaseItem.Rarity.RARE].append(res.duplicate())
						items[BaseItem.Rarity.EPIC].append(res.duplicate())
						items[BaseItem.Rarity.LEGENDARY].append(res.duplicate())
						print(res.name)
					_:
						print("Erreur: ", res.rarity)
						
				print(res.name)
		file_name = dir.get_next()

	dir.list_dir_end()

func setup():
	reroll_button.disabled = false
	attemps = base_attemps
	cash.text = str(game_manager.amount_of_star)
	rounds.text = "Boutique (Vague %d)" % game_manager.current_round
	next_round.text = "Continuer (Vague %d)" % (game_manager.current_round + 1)
	display_items()
	#stats_panel.updateStatsLabel(player)
	

func display_items():
	for item in item_cards:
		var tab = get_item()
		item.display_item(tab[0], tab[1])

func get_item():
	var roll = roll_rarity(item_cards[0].player.stats.luck)
	return [items[roll].pick_random(), roll]

func roll_rarity(luck: float) -> BaseItem.Rarity:
	var chance = clamp(luck / 100.0, 0.0, 1.0)

	var weights = {
		BaseItem.Rarity.COMMON: 60.0 * (1.0 - chance),
		BaseItem.Rarity.UNCOMMON: 20.0 * (1.0 - chance * 0.6),
		BaseItem.Rarity.RARE: 12.0 * (1.0 + chance * 0.8),
		BaseItem.Rarity.EPIC: 6.0 * (1.0 + chance * 1.2),
		BaseItem.Rarity.LEGENDARY: 2.0 * (1.0 + chance * 1.6),
	}

	var total := 0.0
	for v in weights.values():
		total += v

	var roll := randf() * total
	var acc := 0.0

	for rarity in weights.keys():
		acc += weights[rarity]
		if roll <= acc:
			return rarity

	return BaseItem.Rarity.COMMON

func on_item_bought(item : BaseItem):
	cash.text = str(game_manager.amount_of_star)
	stats_panel.update_stats()
	var inventory_map = build_inventory_map(game_manager.owned_items)
	$PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Footer/ScrollContainer/GridContainer.set_items(inventory_map)


func _on_next_round_pressed() -> void:
	gm = get_node_or_null(gm_path)
	if gm == null:
		push_error("ShopOverlay: gm est NULL (gm_path non assigné)")
		return
		
	gm.set_state(GameManager.GameState.IN_ROUND)
	
#  modif idee de base
func build_inventory_map(itemss: Array) -> Dictionary:
	var map := {}

	for item in itemss:
		if not map.has(item.name):
			map[item.name] = {
				"item": item,
				"count": 1
			}
		else:
			map[item.name]["count"] += 1
	return map
	

func _on_reroll_pressed() -> void:
	attemps -= 1
	if attemps == 0:
		reroll_button.disabled = true
	display_items()
