extends Area2D
class_name BaseBullet

var speed: float
var damage: float
var attack_range: float
var travelled_distance: float = 0.0

func setup(p_speed, p_damage, p_range):
	speed = p_speed
	damage = p_damage
	attack_range = p_range
	
func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	var distance = speed * delta
	position += transform.x * distance
	travelled_distance += distance
	if travelled_distance >= attack_range:
		call_deferred("destroy")
		
func _on_body_entered(body) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		call_deferred("destroy")

func destroy():
	queue_free()
