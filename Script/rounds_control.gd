extends Control

@export var ship_full_width := 220.0  
@export var boost_full_width := 120.0 

@export var ship_tip_px := 26.0     
@export var boost_tip_px := 20.0

@onready var ship: TextureRect = $TopLeft/VBoxContainer/HBoxContainer/ShipIcon
@onready var boost: TextureRect = $TopLeft/VBoxContainer/HBoxContainer/PlayerHealthBar

func set_values(ship_ratio: float, boost_ratio: float) -> void:
	ship_ratio = clamp(ship_ratio, 0.0, 1.0)
	boost_ratio = clamp(boost_ratio, 0.0, 1.0)

	if ship.has_method("set_ratio"):
		ship.set_ratio(ship_ratio)
	if boost.has_method("set_ratio"):
		boost.set_ratio(boost_ratio)

	var ship_visible_w := ship_full_width * ship_ratio
	ship_visible_w = max(0.0, ship_visible_w)

	boost.position.x = ship.position.x + ship_visible_w
	boost.size.x = boost_full_width
