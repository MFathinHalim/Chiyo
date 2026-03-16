extends Area2D

signal hide_interact(sign)
signal show_interact(sign)
signal trigger_dialog(lines: Array[Dictionary])

@onready var popup: Sprite2D = $popup

# ================================
# Dialog lines sekarang dictionary
# ================================
@export var dialog_lines: Array[Dictionary] = [
	{ "name": "", "text": "" },
]
func _ready():
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.register_sign(self)

# ================================
# PLAYER MASUK AREA
# ================================
func _on_body_entered(body):
	show_interact.emit(self)
	if not OS.has_feature("mobile"):
		popup.visible = true

# ================================
# PLAYER KELUAR AREA
# ================================
func _on_body_exited(body):
	hide_interact.emit(self)
	popup.visible = false

# ================================
# INTERACT
# ================================
func interact():
	# emit dialog_lines sekarang array of dictionary
	trigger_dialog.emit(dialog_lines)
	popup.visible = false
