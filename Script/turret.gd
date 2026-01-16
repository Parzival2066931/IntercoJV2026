extends Node2D
class_name Turret

@export var turret_stats: TurretStats
var stats: TurretStats

var shooting_style
var lazer

func _ready() -> void:
	if turret_stats == null:
		return
	stats = turret_stats.duplicate()
	%TurretCanon.texture = stats.sprite
	%TurretCanon.flip_h = stats.flip_h
	%TurretCanon.scale = stats.visual_scale
	%TurretCanon.position = stats.sprite_offset
	%TurretCanon.rotation = stats.rotation
	%Muzzle.position = stats.muzzle_offset
	%Range/CollisionShape2D.shape.radius = stats.attack_range
	%Range.position = %TurretCanon.position
	$FireSound.stream = stats.fire_sound
	shooting_style = stats.shooting_style
	if shooting_style == TurretStats.Shooting_style.LAZER:
		lazer = stats.projectile_scene.instantiate()
		%Muzzle.add_child(lazer)
		lazer.position = Vector2.ZERO
		lazer.is_casting = false
		lazer.set_width(stats.lazer_width)
		if stats.seperates_lazer_shots:
			lazer.growth_time = 0.1

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if stats == null: return
	attack(get_closest_enemy())
	#$Pivot.look_at(get_global_mouse_position())
	#shoot_lazer()
	
	
func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest_enemy = null
	var shortest_distance = stats.attack_range

	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)

		if distance <= shortest_distance:
			shortest_distance = distance
			closest_enemy = enemy
	
	return closest_enemy

func attack(enemy):
	if enemy !=  null:
		$Pivot.look_at(enemy.global_position)
		match shooting_style:
			TurretStats.Shooting_style.LAZER:
				shoot_lazer()
			TurretStats.Shooting_style.PROJECTILE:
				shoot()
	else:
		if shooting_style == TurretStats.Shooting_style.LAZER:
			lazer.set_is_casting(false)
		#$Pivot.global_rotation = 0
			
	#if abs(global_rotation) > PI/2:
		#$Pivot.scale.y = -1
	#else:
		#$Pivot.scale.y = 1
		
func shoot_lazer():
	if not %AttackTimer.is_stopped():
		return
	print(stats.resource_path.get_file())
	if stats.seperates_lazer_shots == false:
		if $FireSound.playing:
			print("pass")
			pass 
		else:
			$FireSound.volume_db = stats.sound_volume
			$FireSound.play()
			print("Play")
	else:
		$FireSound.volume_db = stats.sound_volume
		$FireSound.play()
	lazer.set_is_casting(true)
	lazer.force_raycast_update()
	
	var enemy = lazer.get_collider()
	if enemy and enemy.has_method("take_damage"):
		enemy.take_damage(stats.damage)
	%AttackTimer.start(stats.fire_rate)
	
	if stats.seperates_lazer_shots:
		await get_tree().create_timer(0.5).timeout
		lazer.set_is_casting(false)
	
func shoot():
	if not %AttackTimer.is_stopped():
		return
	for i in range(stats.projectile_count):
		
		var bullet = stats.projectile_scene.instantiate()
		bullet.global_position = %Muzzle.global_position
		bullet.global_rotation = %Muzzle.global_rotation
		
		if bullet.has_method("setup"):
			bullet.setup(
				stats.projectile_speed, 
				stats.damage,
				stats.attack_range
			)
		
		bullet.modulate = $Base.modulate
		
		get_tree().current_scene.add_child(bullet)
	$FireSound.volume_db = stats.sound_volume
	$FireSound.play()
	#$FireSound.pitch_scale = randf_range(0.8, 1.2)
	%AttackTimer.start(stats.fire_rate)

func change_color(color : Color):
	$Base.modulate = color
	if shooting_style == TurretStats.Shooting_style.LAZER:
		lazer.set_color(color)

func modify_turret(turret_stats : TurretStats):
	stats.damage = turret_stats.damage
