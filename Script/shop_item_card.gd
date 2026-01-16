extends PanelContainer
class_name ShopItemCard

var multiplier := 1.75

@onready var icon:  =  $MarginContainer/Item/ItemHeader/PanelContainer/ItemDisplay
@onready var name_label = $MarginContainer/Item/ItemHeader/Itemname
@onready var price_label = $MarginContainer/Item/ItemFoot/StarsUi/Amount
@onready var buy_button = $MarginContainer/Item/ItemFoot/BuyButton
@onready var stats: Label = $MarginContainer/Item/ItemBody/Description
var player : Player 
var game_manager: GameManager

var current_item: BaseItem
var current_rarity

var rarity_color = {
	BaseItem.Rarity.COMMON: Color("ffffff"),
	BaseItem.Rarity.UNCOMMON: Color("2cb93c"),
	BaseItem.Rarity.RARE: Color("5e8db5"),
	BaseItem.Rarity.EPIC: Color("8c4ed1"),
	BaseItem.Rarity.LEGENDARY: Color("ff0e06")
}
signal item_bought

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player") 
	game_manager = get_tree().current_scene.get_node("GameManager")
	for c in get_children():
		if c is Control and c != buy_button:
			c.mouse_filter = Control.MOUSE_FILTER_IGNORE

#nill car pas d'objet pour l'instant sois disant
func display_item(temp_item: BaseItem, exponent : int):
	var item = temp_item.duplicate()
	buy_button.text = "Acheter"
	buy_button.disabled = false
	
	current_rarity = exponent
	
	if item.rarity == BaseItem.Rarity.ALL:
		var temp_multiplier = pow(multiplier, exponent)
		adjust_item(item, temp_multiplier)
	
	current_item = item
	icon.texture = item.icon
	name_label.text = item.name
	var c: Color = rarity_color[exponent]
	$TextureRect.modulate = c
	current_item.modulate = rarity_color[exponent]
	#name_label.add_theme_color_override("font_color", c)
#
	#var sb := get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	#sb.bg_color = c.darkened(0.8)
	#sb.border_color = c
	#add_theme_stylebox_override("panel", sb)

	stats.text = generate_description(item)
	price_label.text = str(item.price)
	
func adjust_item(item : BaseItem, temp_multiplier : float):
	if item is TurretItem:
		item.turret_stats.damage *= temp_multiplier
		item.price *= temp_multiplier
	elif item is StatItem:
		item.price *= temp_multiplier
		if item.hp > 0: 
			item.hp *= temp_multiplier
		if item.hp_regen > 0: 
			item.hp_regen *= temp_multiplier
		if item.armor > 0: 
			item.armor *= temp_multiplier
		if item.damage > 0: 
			item.damage *= temp_multiplier
		if item.speed > 0: 
			item.speed *= temp_multiplier
		if item.attack_range > 0: 
			item.attack_range *= temp_multiplier
		if item.luck > 0: 
			item.luck *= temp_multiplier
		if item.hp_percent > 0: 
			item.hp_percent *= temp_multiplier
		if item.damage_percent > 0: 
			item.damage_percent *= temp_multiplier
		if item.speed_percent > 0: 
			item.speed_percent *= temp_multiplier
		if item.attack_speed_percent > 0:
			item.attack_speed_percent *= temp_multiplier
		
func _on_buy_pressed():
	if  game_manager.amount_of_star < current_item.price:
		print("Pas assez de cash")
		return
		
	game_manager.on_cash_changed(-current_item.price)
	buy_button.text = "Vendu"
	buy_button.disabled = true
	var unique_item = current_item.duplicate()
	game_manager.owned_items.append(unique_item)
	unique_item.apply_effect(player, game_manager, rarity_color[current_rarity])
	item_bought.emit(current_item)
	

func generate_description(item: BaseItem) -> String:
	var final_text = ""
	
	if item.description != "":
		final_text += item.description + "\n"
	
	if item is StatItem:
		if item.hp != 0: 
			final_text += "%+d HP\n" % item.hp
		if item.hp_regen != 0: 
			final_text += "%+d HP Régén.\n" % item.hp_regen
		if item.armor != 0: 
			final_text += "%+d Armure\n" % item.armor
		if item.damage != 0: 
			final_text += "%+d Dégâts\n" % item.damage
		if item.speed != 0: 
			final_text += "%+d Vitesse\n" % item.speed
		if item.attack_range != 0: 
			final_text += "%+d Portée\n" % item.attack_range
		if item.luck != 0: 
			final_text += "%+d Chance\n" % item.luck
		if item.hp_percent != 0: 
			final_text += "%+d%% HP\n" % (item.hp_percent * 100)
		if item.damage_percent != 0: 
			final_text += "%+d%% Dégâts\n" % (item.damage_percent * 100)
		if item.speed_percent != 0: 
			final_text += "%+d%% Vitesse\n" % (item.speed_percent * 100)
		if item.attack_speed_percent != 0:
			final_text += "%+d%% Vit. Attaque\n" % (item.attack_speed_percent * 100)
			
	##a modif mais on voit l'idée
	#elif item is TurretItem:
		#if item.turret_stats.damage != 0:
#w			final_text += "%+d de Dégat\n" % item.turret_stats.damage
		#if item.turret_stats.attack_speed != 0:
			#final_text += "%+d Vitesse d'attaque \n" % item.turret_stats.attack_speed
		#if item.turret_stats.projectile_speed != 0:
			#final_text += "%+d Vitesse de projectiles\n" % item.turret_stats.projectile_speed
		#if item.turret_stats.attack_range != 0:
			#final_text += "%+d Distance d'attaque\n" % item.turret_stats.attack_range
		
	return final_text
