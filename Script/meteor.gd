extends Area2D
class_name Meteor

@export var speed := 600.0
@export var base_damage := 25.0
var dir := Vector2.ZERO

var damage: float

func setup(direction: Vector2) -> void:
	dir = direction.normalized()

func _physics_process(delta: float) -> void:
	position += dir * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("is_attacked"):
		body.is_attacked(base_damage)
		
func set_difficulty(mult: float):
	damage = base_damage * mult


func _on_life_time_timeout() -> void:
	queue_free()
