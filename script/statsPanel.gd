extends Node

@onready var stats_container := $MarginContainer/VBoxContainer/Body
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#j'imagine que .stats cest chiffre pis donne pogne manuel? avec le shop si y connais ou proche
func add_stat_code(name: String, value ):
	var hbox = HBoxContainer.new()

	var label_name = Label.new()
	label_name.text = name

	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var label_value = Label.new()
	label_value.text = str(value)

	hbox.add_child(label_name)
	hbox.add_child(spacer)
	hbox.add_child(label_value)

	stats_container.add_child(hbox)
