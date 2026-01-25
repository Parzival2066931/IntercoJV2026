extends CanvasLayer
class_name Hud

@export var ship: PackedScene

@onready var star_label: Label = $RoundsControl/TopLeft/VBoxContainer/Stars_label/Label
@onready var time_label: Label = $RoundsControl/TopRight/Round_Timer
@onready var round_label: Label = $RoundsControl/ButtomCenter/Current_Round
@onready var player_health_bar: TextureRect = $RoundsControl/TopLeft/VBoxContainer/HBoxContainer/PlayerHealthBar
@onready var depart: AnimatedSprite2D = $StartShip/Depart
@onready var decollage: Sprite2D = $StartShip/Decollage
@onready var muzzle: Marker2D = $StartShip/Muzzle

signal spawn_ship_request(pos: Vector2, ship: PackedScene)

func _ready() -> void:
	print("HUD ready")
	decollage.hide()
	depart.hide()
	

func set_round(current_round: int) -> void:
	round_label.text = str(current_round)

func set_time_left(seconds_left: float) -> void:
	time_label.text = _format_time(seconds_left)

func hide_timer():
	time_label.text = "!!! Vaincre le boss !!!"

func set_cash(amount: int) -> void:
	star_label.text = str(amount)

func set_hp(hp: float, max_hp: float) -> void:
	player_health_bar.set_ratio(hp / max_hp)

func _format_time(t: float) -> String:
	var total := int(ceil(t))
	var minutes := total / 60.0
	var seconds := total % 60
	return "%02d:%02d" % [minutes, seconds]

func _on_depart_animation_finished() -> void:
	depart.hide()
	decollage.visible = true
	spawn_ship_request.emit(muzzle.position, ship)
