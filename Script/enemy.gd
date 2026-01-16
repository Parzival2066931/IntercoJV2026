extends CharacterBody2D

func _process(delta : float):
	global_position = get_global_mouse_position()

func take_damage(damage : float):
	pass
