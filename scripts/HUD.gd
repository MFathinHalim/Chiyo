extends Node2D
@onready var coins: Node = $Coins
@onready var score_text: Label = $CanvasLayer/Control/coinui/HBoxContainer/Score2
@onready var nyawa_1: TextureRect = $"CanvasLayer/Control/Nyawa/HBoxContainer/Nyawa 1"
@onready var nyawa_2: TextureRect = $"CanvasLayer/Control/Nyawa/HBoxContainer/Nyawa 2"
@onready var nyawa_3: TextureRect = $"CanvasLayer/Control/Nyawa/HBoxContainer/Nyawa 3"
@onready var mabuk: TextureRect = $CanvasLayer/Control/coinui/HBoxContainer/Mabok
@onready var game_over: ColorRect = $"CanvasLayer/Control/Game Over"
@onready var textbox = $TextBox
@onready var press_g: Button = $TextBox/PressG

var current_sign: Area2D = null
var isRead = false

func register_sign(sign: Area2D):
	sign.show_interact.connect(_on_show_prompt)
	sign.hide_interact.connect(_on_hide_prompt)
	sign.trigger_dialog.connect(_on_trigger_dialog)

func _on_show_prompt(sign):
	current_sign = sign
	press_g.visible = true

func _on_hide_prompt(sign):
	if current_sign == sign:
		current_sign = null
	press_g.visible = false
	
func _on_trigger_dialog(lines):
	textbox.start_dialog(lines)

func _ready():
	GameManager.total = coins.get_child_count()
	press_g.visible = false
	if OS.has_feature("mobile"):
		press_g.text = "Check Sign"
	update_ui()

func _process(delta: float):
	if press_g.visible and Input.is_action_just_pressed("ui_accept"):
		if current_sign:
			current_sign.interact()
			press_g.visible = false
	update_ui()

func update_ui():
	score_text.text = "%d/%d" % [
		GameManager.score,
		GameManager.total
	]
	
	if (GameManager.SPEED == 200):
		mabuk.visible = true
	else:
		mabuk.visible = false
	
	nyawa_2.visible = not GameManager.nyawa < 2
	nyawa_3.visible = not GameManager.nyawa < 3
	nyawa_1.visible = not GameManager.nyawa < 1

	if(GameManager.over):
		game_over.visible = true
