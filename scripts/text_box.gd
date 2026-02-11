extends CanvasLayer

signal dialog_finished

const CHAR_READ_RATE = 0.05

@onready var textbox_container: MarginContainer = $TextboxContainer
@onready var start_symbol: Label = $TextboxContainer/Panel/MarginContainer/HBoxContainer/Star
@onready var end_symbol: Label = $TextboxContainer/Panel/MarginContainer/HBoxContainer/V
@onready var label: RichTextLabel = $TextboxContainer/Panel/MarginContainer/HBoxContainer/Label

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue: Array[String] = []
var tween: Tween

func _ready():
	hide_textbox()

func start_dialog(lines: Array[String]):
	text_queue = lines.duplicate()
	print(text_queue)
	change_state(State.READY)
	show_textbox()

func _process(delta):
	match current_state:
		State.READY:
			if not text_queue.is_empty():
				display_text()
				show_textbox()
				print("test")

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

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.visible_ratio = 0.0
	show_textbox()
	change_state(State.READING)

	tween = create_tween()
	tween.tween_property(
		label,
		"visible_ratio",
		1.0,
		next_text.length() * CHAR_READ_RATE
	)

	tween.finished.connect(_on_tween_finished)

func change_state(next_state):
	current_state = next_state

func _on_tween_finished():
	end_symbol.text = "v"
	change_state(State.FINISHED)
