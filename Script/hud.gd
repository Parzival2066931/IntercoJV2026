extends CanvasLayer
class_name Hud #je ne trouve pas le mode pause_mode dans l'inspecteur

@onready var star_label: Label = $RoundsControl/TopLeft/VBoxContainer/Stars_label/Label
@onready var time_label: Label = $RoundsControl/TopRight/Round_Timer
@onready var round_label: Label = $RoundsControl/ButtomCenter/Current_Round
@onready var health_bar: TextureProgressBar = $RoundsControl/TopLeft/VBoxContainer/PlayerHealthBar
@onready var health_label: Label = $RoundsControl/TopLeft/VBoxContainer/PlayerHealthBar/Label

func _ready() -> void:
	print("HUD ready")

func set_round(current_round: int) -> void:
	round_label.text = str(current_round)

func set_time_left(seconds_left: float) -> void:
	time_label.text = _format_time(seconds_left)

func hide_timer():
	time_label.text = "!!! Vaincre le boss !!!"

func set_cash(amount: int) -> void:
	print("plus d'argent! du HUD")
	star_label.text = str(amount)

func set_hp(hp: float, max_hp: float) -> void:
	health_bar.max_value = max_hp
	health_bar.value = hp
	health_label.text = str(int(round(hp)), "/", int(round(max_hp)))

func _format_time(t: float) -> String:
	var total := int(ceil(t))
	var minutes := total / 60.0
	var seconds := total % 60
	return "%02d:%02d" % [minutes, seconds]
