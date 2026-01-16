extends Area2D

@export var margin := 100.0

@onready var col: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_exited.connect(_on_body_exited)
	var map_sprite = get_tree().current_scene.find_child("Map")

	if map_sprite:
		var tex_size = map_sprite.texture.get_size()
		var world_size = tex_size * map_sprite.global_scale
		var half = world_size * 0.5
		
		var left = map_sprite.global_position.x - half.x + margin
		var right = map_sprite.global_position.x + half.x - margin
		var top = map_sprite.global_position.y - half.y + margin
		var bottom = map_sprite.global_position.y + half.y - margin
		
		var w = max(0.0, right - left)
		var h = max(0.0, bottom - top)

		global_position = Vector2((left + right) * 0.5, (top + bottom) * 0.5)

		var shape := col.shape as RectangleShape2D
		if shape == null:
			shape = RectangleShape2D.new()
			col.shape = shape

		shape.size = Vector2(w, h)

	print("Area monitoring=", monitoring, " layer=", collision_layer, " mask=", collision_mask)

func _on_body_exited(body: Node2D) -> void:
	body.get_node("TP_Timer").start()
	body.get_node("Trail2D").visible = false
	body.global_position = -body.global_position
