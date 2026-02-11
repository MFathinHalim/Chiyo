extends Area2D

signal hide_interact(sign)
signal show_interact(sign)
signal trigger_dialog(lines)

@export_multiline var dialog_lines: Array[String] = []
func _ready():
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.register_sign(self)

func _on_body_entered(body):
	show_interact.emit(self)
func _on_body_exited(body):
	hide_interact.emit(self)
func interact():
	trigger_dialog.emit(dialog_lines)
