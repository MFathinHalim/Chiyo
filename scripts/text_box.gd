extends CanvasLayer

signal dialog_finished

const CHAR_READ_RATE = 0.05

# =======================
# NODES
# =======================
@onready var textbox_container: MarginContainer = $TextboxContainer
@onready var name_label: Label = $TextboxContainer/Panel/MarginContainer/VBoxContainer/NameLabel
@onready var end_symbol: Label = $TextboxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/V
@onready var label: RichTextLabel = $TextboxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Label

# =======================
# STATES
# =======================
enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue: Array[Dictionary] = [] # sekarang tiap item: { "name": "Aditya", "text": "Hello!" }
var tween: Tween

# =======================
# READY
# =======================
func _ready():
	hide_textbox()

# =======================
# START DIALOG
# =======================
# lines: array of dictionaries { "name": "Aditya", "text": "Hello!" }
func start_dialog(lines: Array[Dictionary]):
	text_queue = lines.duplicate()
	change_state(State.READY)
	show_textbox()

# =======================
# PROCESS
# =======================
func _process(delta):
	match current_state:
		State.READY:
			if not text_queue.is_empty():
				display_text()
				show_textbox()

		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_ratio = 1.0
				if tween:
					tween.kill()
				end_symbol.text = "v"
				change_state(State.FINISHED)

		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				if text_queue.is_empty():
					hide_textbox()
					change_state(State.READY)
					dialog_finished.emit()
				else:
					change_state(State.READY)

# =======================
# SHOW / HIDE
# =======================
func hide_textbox():
	name_label.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	textbox_container.show()

# =======================
# DISPLAY TEXT
# =======================
func display_text():
	var next_line = text_queue.pop_front()
	var character_name = next_line.get("name", "")
	var text = next_line.get("text", "")
	
	name_label.text = character_name
	label.text = text
	label.visible_ratio = 0.0
	end_symbol.text = ""
	show_textbox()
	
	change_state(State.READING)

	tween = create_tween()
	tween.tween_property(
		label,
		"visible_ratio",
		1.0,
		text.length() * CHAR_READ_RATE
	)
	tween.finished.connect(_on_tween_finished)

# =======================
# STATE CHANGE
# =======================
func change_state(next_state):
	current_state = next_state

func _on_tween_finished():
	end_symbol.text = "v"
	change_state(State.FINISHED)
