extends Area2D


@onready var col: CollisionShape2D = $CollisionShape2D
@onready var player = get_tree().current_scene.find_child("Player")
@onready var map_sprite = get_tree().current_scene.find_child("Map")

var left: float
var right: float
var top: float
var bottom: float
var margin := 100.0

func _ready() -> void:
	body_exited.connect(_on_body_exited)
	player.scale_changed.connect(on_player_scale_changed)
	draw_zone()

	print("Area monitoring=", monitoring, " layer=", collision_layer, " mask=", collision_mask)

func _on_body_exited(body: Node2D) -> void:
	
	body.get_node("TP_Timer").start()
	body.get_node("Trail2D").clear_points()
	body.get_node("Trail2D").visible = false
	
	if body.global_position.x < left || body.global_position.x > right:
		body.global_position.x = -body.global_position.x
	if body.global_position.y < top || body.global_position.y > bottom:
		body.global_position.y = -body.global_position.y

func on_player_scale_changed():
	margin = player.scale.x * 130.0
	draw_zone()

func draw_zone():
	if map_sprite:
		var tex_size = map_sprite.texture.get_size()
		var world_size = tex_size * map_sprite.global_scale
		var half = world_size * 0.5
		
		left = map_sprite.global_position.x - half.x + margin
		right = map_sprite.global_position.x + half.x - margin
		top = map_sprite.global_position.y - half.y + margin
		bottom = map_sprite.global_position.y + half.y - margin
		
		var w = max(0.0, right - left)
		var h = max(0.0, bottom - top)

		global_position = Vector2((left + right) * 0.5, (top + bottom) * 0.5)

		var shape := col.shape as RectangleShape2D
		if shape == null:
			shape = RectangleShape2D.new()
			col.shape = shape

		shape.size = Vector2(w, h)
