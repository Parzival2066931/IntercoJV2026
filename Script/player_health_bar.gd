extends TextureRect

@export var tip_px := 26.0
@export var keep_full_tip := false
@export var hide_when_empty := true

@onready var _mat: ShaderMaterial = null

func _ready() -> void:
	# Sécurité: s'assurer d'avoir un ShaderMaterial
	if material == null or not (material is ShaderMaterial):
		push_error("%s: Material doit être un ShaderMaterial" % name)
		return

	_mat = material as ShaderMaterial

	# Init paramètres shader
	_mat.set_shader_parameter("tip_px", tip_px)
	_mat.set_shader_parameter("keep_full_tip", keep_full_tip)
	_mat.set_shader_parameter("bar_width_px", size.x)

	# Valeur par défaut
	_mat.set_shader_parameter("progress", 1.0)
	if hide_when_empty:
		visible = true

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED and _mat:
		_mat.set_shader_parameter("bar_width_px", size.x)


func set_ratio(r: float) -> void:
	if _mat == null:
		return

	r = clamp(r, 0.0, 1.0)
	_mat.set_shader_parameter("progress", r)

	# Optionnel: cacher la barre à 0 (utile si keep_full_tip=true)
	if hide_when_empty:
		visible = r > 0.0
