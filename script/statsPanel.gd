extends Node
class_name StatsPanel

# Labels pour les clés et valeurs
@onready var stats_key: Label = $MarginContainer/VBoxContainer/Body/StatsContainer/KeyContainer/StatsKey
@onready var stats_value: Label = $MarginContainer/VBoxContainer/Body/StatsContainer/StatsValue/StatsValue


var player: Player


func bind_player(p: Player) -> void:
	player = p
	update_stats()

func update_stats() -> void:
	print("alloa")
	if player == null or player.stats == null:
		return
	print("loalo")
	stats_key.text = generate_keyname()
	stats_value.text = generate_value()

func generate_value() -> String:
	var s = player.stats
	var txt := ""

	txt += "%d\n" % s.get_total_max_hp()
	txt += "%0.1f\n" % s.hp_regen
	txt += "%d\n" % s.get_total_speed()
	txt += "%d\n" % s.armor
	txt += "%d\n" % s.base_damage
	txt += "%d\n" % s.attack_range
	txt += "%d%%\n" % int(s.hp_percent_modifier * 100)
	txt += "%d%%\n" % int(s.damage_percent_modifier * 100)
	txt += "%d%%\n" % int(s.speed_percent_modifier * 100)
	txt += "%d%%\n" % int(s.attack_speed_percent_modifier * 100)
	txt += "%d\n" % s.luck

	return txt

func generate_keyname() -> String:
	#var s = player.stats
	var txt := ""
	txt += "Vie max\n"
	txt += "Régénération\n"
	txt += "Vitesse\n"
	txt += "Armure\n"
	txt += "Dégâts de base\n"
	txt += "Portée\n"
	txt += "Vie max %\n"
	txt += "Dégâts %\n"
	txt += "Vitesse %\n"
	txt += "Vitesse d'attaque %\n"
	txt += "Chance\n"

	return txt
