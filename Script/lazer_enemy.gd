extends Enemy
class_name LazerEnemy

func _ready() -> void:
	print(base_max_hp)
	super()


func _on_attack_cooldown_timeout() -> void:
	%Canons.shoot()
