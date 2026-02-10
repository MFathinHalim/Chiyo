extends Node2D
@onready var coins: Node = $Coins
@onready var score_text: Label = $CanvasLayer/coinui/Score2
@onready var nyawa_1: AnimatedSprite2D = $"CanvasLayer/Nyawa/Nyawa 1"
@onready var nyawa_2: AnimatedSprite2D = $"CanvasLayer/Nyawa/Nyawa 2"
@onready var nyawa_3: AnimatedSprite2D = $"CanvasLayer/Nyawa/Nyawa 3"
@onready var mabuk: AnimatedSprite2D = $CanvasLayer/Nyawa/mabuk

func _ready():
	GameManager.total = coins.get_child_count()
	update_ui()

func _process(delta: float):
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
