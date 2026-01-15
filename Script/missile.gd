extends BaseBullet

func _process(delta: float) -> void:
	look_at(get_closest_enemy().global_position)

func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_enemy = null
	var shortest_distance = 500

	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)

		if distance <= shortest_distance:
			shortest_distance = distance
			closest_enemy = enemy
	
	return closest_enemy
