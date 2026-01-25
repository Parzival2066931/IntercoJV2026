extends GridContainer
class_name InventoryGrid

@export var item_slot_scene: PackedScene  # assigne ici ta scène ItemSlot

var last_d: Dictionary = {}

func set_items(d: Dictionary) -> void:
	if d == last_d:
		return
	last_d = d.duplicate()

	for child in get_children():
		child.queue_free()

	for key in d.keys():
		var entry = d[key]
		var item = entry["item"]
		var count = entry["count"]

		var slot = item_slot_scene.instantiate()
		slot.setup(item, count)
		add_child(slot)
