extends Area2D


@export var base_loot: int

signal easter_egg_found

func _ready() -> void:
	$AnimatedSprite2D.play("monster_egg")


func _physics_process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	easter_egg_found.emit(base_loot)
	queue_free()
