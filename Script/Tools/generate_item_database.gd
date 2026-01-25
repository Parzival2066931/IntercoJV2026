@tool
extends EditorScript

const ITEMS_DIR := "res://Assets/items/resources/"
const OUT_PATH  := "res://Assets/items/ItemDatabase.tres"

func _run():
	var db := ItemDatabase.new()
	var dir := DirAccess.open(ITEMS_DIR)
	if dir == null:
		push_error("Impossible d’ouvrir: " + ITEMS_DIR)
		return

	dir.list_dir_begin()
	var f := dir.get_next()
	while f != "":
		if not dir.current_is_dir() and f.ends_with(".tres"):
			var p := ITEMS_DIR + f
			var res := load(p)
			if res is BaseItem:
				db.all_items.append(res)
		f = dir.get_next()
	dir.list_dir_end()

	ResourceSaver.save(db, OUT_PATH)
	print("DB générée: ", OUT_PATH, " items=", db.all_items.size())
