extends Area2D
class_name Star

signal star_collected(amount: int)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("star")

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if(body.name == "Player"):
	
		var amount = 1 + randi() % 3 #var amount = 1 + randi() % (1 + body.player_stats.luck / 2)
		star_collected.emit(amount)
		queue_free()
