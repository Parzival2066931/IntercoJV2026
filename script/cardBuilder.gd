extends PanelContainer
class_name ShopItemCard

#
#
@onready var icon:  = $MarginContainer/Item/ItemHeader/ItemDisplay
@onready var name_label = $MarginContainer/Item/ItemHeader/Itemname
@onready var price_label = $MarginContainer/VBoxContainer/Pricing/Cash/Label
@onready var buy_button = $MarginContainer/Item/ItemFoot/BuyButton
@onready var stats: Label = $MarginContainer/VBoxContainer/Stats
var player : Player 
var game_manager: GameManager

var current_item: BaseItem

var rarity_color = {
	BaseItem.Rarity.COMMON: Color("ffffff"),
	BaseItem.Rarity.UNCOMMON: Color("2cb93c"),
	BaseItem.Rarity.RARE: Color("5e8db5"),
	BaseItem.Rarity.EPIC: Color("8c4ed1"),
	BaseItem.Rarity.LEGENDARY: Color("ffb93c")
}
signal item_bought

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player") 
	game_manager = get_tree().current_scene.get_node("GameManager")


func display_item(item: BaseItem):
	buy_button.text = "Buy"
	buy_button.disabled = false
	
	current_item = item
	icon.texture = item.icon
	name_label.text = item.name
	var c: Color = rarity_color[item.rarity]

	name_label.add_theme_color_override("font_color", c)

	var sb := get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	sb.bg_color = c.darkened(0.8)
	sb.border_color = c
	add_theme_stylebox_override("panel", sb)

	stats.text = generate_description(item)
	price_label.text = str(item.price)
	

func _on_buy_pressed():
	if  game_manager.amount_of_coin < current_item.price:
		print("Pas assez de cash")
		return
	game_manager.on_cash_changed(-current_item.price)
	buy_button.text = "Sold"
	buy_button.disabled = true
	var unique_item = current_item.duplicate()
	game_manager.owned_items.append(unique_item)
	unique_item.apply_effect(player, game_manager)
	item_bought.emit()

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
		if item.penetration != 0: 
			final_text += "%+d Pénétration\n" % item.penetration
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
	elif item is TurretItem:
		if item.damage != 0:
			final_text += "%+d de Dégat\n" % item.damage
		if item.damage != 0:
			final_text += "%+d Vitesse d'attaque \n" % item.damage
		if item.fire_rate != 0:
			final_text += "%+d Vitesse de projectiles\n" % item.projectile_speed
		if item.projectile_speed != 0:
			final_text += "%+d Distance d'attaque\n" % item.attack_range
	elif item is SpecialItem:
		if item.description != "":
			final_text += item.description
			
		
	return final_text
