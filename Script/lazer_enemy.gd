extends Enemy
class_name LazerEnemy

func _ready() -> void:
	print("READY node=", name,
		" script_path=", (get_script() as Script).resource_path,
		" scene=", scene_file_path,
		" class=", get_class()
	)
	super()


func _on_attack_cooldown_timeout() -> void:
	%Canons.shoot()
