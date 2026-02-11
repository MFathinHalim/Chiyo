extends CanvasLayer

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
	text_queue.clear()
	for line in lines:
		text_queue.push_back(line)
	change_state(State.READY)

func _process(delta):
	match current_state:
		State.READY:
			if not text_queue.is_empty():
				display_text()

		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_ratio = 1.0
				if tween:
					tween.kill()
				end_symbol.text = "v"
				change_state(State.FINISHED)

		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()

func queue_text(next_text: String):
	text_queue.push_back(next_text)

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


func _on_press_g_button_down() -> void:
	Input.action_press("ui_accept")
	Input.action_release("ui_accept")
