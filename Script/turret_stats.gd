extends Resource
class_name TurretStats

enum Shooting_style { LAZER, PROJECTILE }

@export_group("Visuel")
@export var weapon_name: String = "Arme"
@export var sprite: Texture2D
@export var bullet_sprite: Texture2D
@export var visual_scale: Vector2 = Vector2(1, 1)
@export var flip_h: bool = false
@export var muzzle_offset: Vector2 = Vector2.ZERO
@export var sprite_offset: Vector2 = Vector2.ZERO
@export var rotation : float = 0.0
@export var fire_sound: AudioStream

@export_group("Combat")
@export var damage: float = 10.0
@export var fire_rate: float = 0.5
@export var projectile_speed: float = 600.0
@export var attack_range: float = 400.0

@export_group("Spécificités")
@export var projectile_count: int = 1
@export var shooting_style : Shooting_style
@export var seperates_lazer_shots := false
@export var lazer_width := 2.0
@export var projectile_scene: PackedScene # = preload("res://scenes/bullets/base_bullet.tscn")
