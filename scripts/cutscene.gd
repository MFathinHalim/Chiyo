extends CanvasLayer

@onready var background: TextureRect = $Background
@onready var textbox = $TextBox

var next_scene_path: String

func play_cutscene(bg: Texture2D, lines: Array[String], next_scene: String):
	background.texture = bg
	next_scene_path = next_scene
	
	textbox.start_dialog(lines)
	textbox.dialog_finished.connect(_on_dialog_finished)

func _on_dialog_finished():
	get_tree().change_scene_to_file(next_scene_path)
	queue_free()
