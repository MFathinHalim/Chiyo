extends Area2D

signal hide_interact(sign)
signal show_interact(sign)
signal trigger_dialog(lines)

@export_multiline var dialog_lines: Array[String] = []
@export var already: bool = false
func _ready():
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.register_sign(self)

func _on_body_entered(body):
	if not already:
		already = true
		interact()
func _on_body_exited(body):
	already = true
func interact():
	trigger_dialog.emit(dialog_lines)
