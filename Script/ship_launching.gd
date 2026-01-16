extends Area2D
class_name ShipLaunching

signal start_game_request

var speed := 150
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Ship.play("Ship")
	$Trail.play("Trail")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= speed * delta


func _on_life_time_timeout() -> void:
	queue_free()
	start_game_request.emit()
