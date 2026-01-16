extends Enemy
class_name Kamikaze

@onready var hurtbox := $Hurtbox
@onready var hurtbox_shape := $Hurtbox/HurtboxShape
@onready var collision_shape_2d := $CollisionShape2D
@onready var die_animation: AnimatedSprite2D = $DieAnimation
@onready var explosion_range: Area2D = $ExplosionRange
@onready var explosion_shape: CollisionShape2D = $ExplosionRange/ExplosionShape
@onready var ship: Sprite2D = $Pivot/Sprite2D


var hit_targets := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	print("READY node=", name,
		" script_path=", (get_script() as Script).resource_path,
		" scene=", scene_file_path,
		" class=", get_class()
	)
	super()
	die_animation.hide()
	
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if player == null:
		return

	var to_player = player.global_position - global_position
	var dist = to_player.length()
	var dir_to_player = to_player.normalized()

		
	
	if not is_dying:
		pivot.look_at(player.global_position)
		
		velocity = dir_to_player * speed
		move_and_slide()

func take_damage(dam: float):
	if is_dying:
		return
	hp -= dam
	health_bar.value = hp
	if (hp <= 0):
		is_dying = true
		disable_combat()
		explosion()

func disable_combat():
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled",true)
	if hurtbox:
		hurtbox.set_deferred("monitoring", false)
		hurtbox.set_deferred("monitorable", false)
		collision_shape_2d.set_deferred("disabled", true)
	

func _on_die_animation_animation_finished() -> void:
	if not is_dying:
		return
	if die_animation.animation != "Explosion 2":
		return
	die_animation.animation_finished.disconnect(_on_die_animation_animation_finished)
	die()

func explosion():
	health_bar.hide()
	ship.visible = false
	die_animation.visible = true
	die_animation.play("Explosion 2")
	
	hit_targets.clear()
	
	explosion_range.set_deferred("monitorable", true)
	explosion_range.set_deferred("monitoring", true)
	
	await get_tree().physics_frame
	_damage_bodies_in_explosion_area()
	
func _damage_bodies_in_explosion_area():
	for body in explosion_range.get_overlapping_bodies():
		_apply_explosion_to(body)
	
	
func _apply_explosion_to(body: Node2D):
	if not is_dying:
		return
		
	var id := body.get_instance_id()
	if hit_targets.has(id):
		return
	hit_targets[id] = true
	
	if body.has_method("is_attacked"):
		explosion_shape.set_deferred("disabled", true)
		body.is_attacked(damage)
	
func _on_explosion_range_body_entered(body: Node2D) -> void:
	_apply_explosion_to(body)
	
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("is_attacked"):
		is_dying = true
		disable_combat()
		explosion()
