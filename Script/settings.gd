extends Control
class_name Settings

@onready var hint_label: Label = %HintLabel

@onready var btn_left: Button = %BindMoveLeft
@onready var btn_right: Button = %BindMoveRight
@onready var btn_up: Button = %BindMoveUp
@onready var btn_down: Button = %BindMoveDown

@onready var menu: Menu = $"../Menu"


var waiting_action: StringName = ""
var waiting_button: Button

func _ready() -> void:
	_refresh_buttons()

	btn_left.pressed.connect(func(): _start_rebind("left", btn_left))
	btn_right.pressed.connect(func(): _start_rebind("right", btn_right))
	btn_up.pressed.connect(func(): _start_rebind("up", btn_up))
	btn_down.pressed.connect(func(): _start_rebind("down", btn_down))

func _start_rebind(action: StringName, button: Button) -> void:
	waiting_action = action
	waiting_button = button
	hint_label.text = "Appuie sur une touche... (ESC pour annuler)"
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if waiting_action == "":
		return

	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_cancel_rebind()
		return

	if event is InputEventKey and event.pressed and not event.echo:
		_apply_key(waiting_action, event)
		_finish_rebind()
		return

func _apply_key(action: StringName, key_event: InputEventKey) -> void:
	for e in InputMap.action_get_events(action):
		InputMap.action_erase_event(action, e)

	InputMap.action_add_event(action, key_event)

func _finish_rebind() -> void:
	waiting_action = ""
	hint_label.text = ""
	set_process_input(false)
	_refresh_buttons()

func _cancel_rebind() -> void:
	waiting_action = ""
	hint_label.text = ""
	set_process_input(false)
	_refresh_buttons()

func _refresh_buttons() -> void:
	btn_left.text = _get_action_as_text("left")
	btn_right.text = _get_action_as_text("right")
	btn_up.text = _get_action_as_text("up")
	btn_down.text = _get_action_as_text("down")

func _get_action_as_text(action: StringName) -> String:
	var events := InputMap.action_get_events(action)
	if events.is_empty():
		return "Non assigné"

	var e := events[0]
	if e is InputEventKey:
		return OS.get_keycode_string(e.keycode)
	return "Assigné"


func _on_back_button_pressed() -> void:
	menu.visible = true
	hide()
