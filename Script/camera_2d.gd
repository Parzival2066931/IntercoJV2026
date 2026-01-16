extends Camera2D

func _ready() -> void:
	var map_sprite = get_tree().current_scene.find_child("Map")

	if map_sprite:
		var rect = map_sprite.get_rect()
		var map_scale = map_sprite.scale
		
		limit_left = map_sprite.global_position.x + (rect.position.x * map_scale.x)
		limit_top = map_sprite.global_position.y + (rect.position.y * map_scale.y)
		limit_right = map_sprite.global_position.x + (rect.end.x * map_scale.x)
		limit_bottom = map_sprite.global_position.y + (rect.end.y * map_scale.y)
