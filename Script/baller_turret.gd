extends Turret

func shoot():
	if not %AttackTimer.is_stopped():
		%BallAnimation.hide()
		return
		
	%BallAnimation.play()
	%BallAnimation.show()
	await %BallAnimation.animation_finished
		
	var bullet = stats.projectile_scene.instantiate()
	bullet.global_position = %Muzzle.global_position
	bullet.global_rotation = %Muzzle.global_rotation
	bullet.get_node("Sprite2D").texture = stats.bullet_sprite
	
	if bullet.has_method("setup"):
		bullet.setup(
			stats.projectile_speed, 
			stats.damage,
			stats.attack_range
		)
		
		get_tree().current_scene.add_child(bullet)
		
	$FireSound.volume_db = -25.0
	$FireSound.play()
	%AttackTimer.start(stats.fire_rate)
