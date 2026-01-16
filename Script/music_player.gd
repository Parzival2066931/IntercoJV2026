extends Node2D
class_name MusicPlayer

@onready var main_music = $MainTheme
@onready var shop_music = $ShopTheme

@export var transtition_time := .5
@export var min_volume = -55
@export var max_volume = -15

var is_shop_mode = false

func _ready():
	main_music.play()
	shop_music.play()
	
	shop_music.volume_db = min_volume
	main_music.volume_db = min_volume

func shop_theme():
	var tween = create_tween()
	tween.tween_property(main_music, "volume_db", min_volume, transtition_time)
	tween.tween_property(shop_music, "volume_db", max_volume, transtition_time)

func main_theme():
	var tween = create_tween()
	tween.tween_property(main_music, "volume_db", max_volume, transtition_time)
	tween.tween_property(shop_music, "volume_db", min_volume, transtition_time)
