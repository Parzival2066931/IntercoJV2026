extends StaticBody2D

@export var margin: float

func _ready():
	var map_sprite = get_tree().current_scene.find_child("Map")
	
	if map_sprite:
		var rect = map_sprite.get_rect()
		var s = map_sprite.scale
		var pos = map_sprite.global_position
		
		var L = pos.x + (rect.position.x * s.x) - margin
		var T = pos.y + (rect.position.y * s.y) - margin
		var R = pos.x + (rect.end.x * s.x) + margin
		var B = pos.y + (rect.end.y * s.y) + margin

		add_wall(Vector2(L, T), Vector2(R, T))
		add_wall(Vector2(L, B), Vector2(R, B))
		add_wall(Vector2(L, T), Vector2(L, B))
		add_wall(Vector2(R, T), Vector2(R, B))

func add_wall(p1: Vector2, p2: Vector2):
	var collision_shape = CollisionShape2D.new()
	var segment = SegmentShape2D.new()
	
	segment.a = p1
	segment.b = p2
	
	collision_shape.shape = segment
	add_child(collision_shape)
