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
#onready var next_round := $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/NextRound
@onready var ship_uid:=  get_node_or_null(ship_ui_display)
@onready var stats_panel := (stats_display)


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
	load_all_items()
	for card in get_tree().get_nodes_in_group("Shop_Cards"):
		card.item_bought.connect(on_item_bought)

func load_all_items():
	var dir := DirAccess.open("res://assets/items/resources/")
	if dir == null:
		print("OUPS")
		push_error("Impossible d’ouvrir le dossier des items")
		return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		if file_name.ends_with(".tres"):
			var path := "res://assets/items/resources/" + file_name
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
						print("COMMON: ")
						print(res)
						items[BaseItem.Rarity.COMMON].append(res)
					BaseItem.Rarity.UNCOMMON:
						print("UNCOMMON: ")
						print(res)
						items[BaseItem.Rarity.UNCOMMON].append(res)
					BaseItem.Rarity.RARE:
						print("RARE: ")
						print(res)
						items[BaseItem.Rarity.RARE].append(res)
					BaseItem.Rarity.EPIC:
						print("EPIC: ")
						print(res)
						items[BaseItem.Rarity.EPIC].append(res)
					BaseItem.Rarity.LEGENDARY:
						print("LEGENDARY: ")
						print(res)
						items[BaseItem.Rarity.LEGENDARY].append(res)
					_:
						print("Erreur: ", res.rarity)
						
				print(res.name)
		file_name = dir.get_next()

	dir.list_dir_end()
	print(items[BaseItem.Rarity.EPIC])

func setup():
	reroll_button.disabled = false
	attemps = base_attemps
	cash.text = str(game_manager.amount_of_coin)
	rounds.text = "Shop (Wave %d)" % game_manager.current_round
	#next_round.text = "Go (Wave %d)" % (game_manager.current_round + 1)
	
	display_items()

func display_items():
	for item in item_cards:
		item.display_item(get_item())

func get_item() -> BaseItem:
	return items[roll_rarity(0)].pick_random()

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


func on_item_bought():
	cash.text = str(game_manager.amount_of_coin)

func _on_next_round_pressed() -> void:
	gm = get_node_or_null(gm_path)
	if gm == null:
		push_error("ShopOverlay: gm est NULL (gm_path non assigné)")
		return
		
	gm.set_state(GameManager.GameState.IN_ROUND)

func _on_reroll_button_pressed() -> void:
	attemps -= 1
	if attemps == 0:
		reroll_button.disabled = true
	display_items()
