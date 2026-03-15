extends Node2D

@onready var coins: Node = $Coins
@onready var enemies: Node = $Slime
@onready var score_text: Label = $CanvasLayer/Control/coinui/HBoxContainer/Score2
@onready var nyawa_1: TextureRect = $"CanvasLayer/Control/Nyawa/HBoxContainer/Nyawa 1"
@onready var nyawa_2: TextureRect = $"CanvasLayer/Control/Nyawa/HBoxContainer/Nyawa 2"
@onready var nyawa_3: TextureRect = $"CanvasLayer/Control/Nyawa/HBoxContainer/Nyawa 3"
@onready var mabuk: TextureRect = $CanvasLayer/Control/coinui/HBoxContainer/Mabok
@onready var game_over: ColorRect = $"CanvasLayer/Control/Game Over"
@onready var textbox = $TextBox
@onready var press_g: Button = $TextBox/PressG
@onready var entity_map: TileMap = %EntityMap

var coin_scene = preload("res://scenes/coin.tscn")
var slime_scene = preload("res://scenes/slime.tscn")

var current_sign = null
var isRead = false

# =========================
# READY
# =========================
func _ready():
	_spawn_entities_from_tilemap()
	
	GameManager.total = coins.get_child_count()
	press_g.visible = false
	
	if OS.has_feature("mobile"):
		press_g.text = "Check Sign"
	
	update_ui()


# =========================
# SPAWN SYSTEM
# =========================
func _spawn_entities_from_tilemap():
	for cell in entity_map.get_used_cells(0):
		var id = entity_map.get_cell_source_id(0, cell)
		var pos = entity_map.map_to_local(cell)
		if id == 2:
			var coin = coin_scene.instantiate()
			coin.global_position = pos
			coins.add_child(coin)
		
		elif id == 3:
			var slime = slime_scene.instantiate()
			slime.global_position = pos
			enemies.add_child(slime)
	
	entity_map.clear()


# =========================
# SIGN SYSTEM
# =========================
func register_sign(sign):
	sign.show_interact.connect(_on_show_prompt)
	sign.hide_interact.connect(_on_hide_prompt)
	sign.trigger_dialog.connect(_on_trigger_dialog)
	call_deferred("_connect_dialog_finished", sign)

func _connect_dialog_finished(sign):
	if textbox and sign.has_method("resume_attack"):
		textbox.dialog_finished.connect(sign.resume_attack)	
func _on_show_prompt(sign):
	press_g.visible = true

func _on_hide_prompt(sign):
	if current_sign == sign:
		current_sign = null
	press_g.visible = false

func _on_trigger_dialog(lines: Array[String]):
	textbox.start_dialog(lines)

# =========================
# PROCESS
# =========================
func _process(delta: float):
	if press_g.visible and Input.is_action_just_pressed("ui_accept"):
		if current_sign:
			current_sign.interact()
			press_g.visible = false
	
	update_ui()


# =========================
# UI UPDATE
# =========================
func update_ui():
	score_text.text = "%d/%d" % [
		GameManager.score,
		GameManager.total
	]
	
	mabuk.visible = (GameManager.SPEED == 200)
	
	nyawa_1.visible = GameManager.nyawa >= 1
	nyawa_2.visible = GameManager.nyawa >= 2
	nyawa_3.visible = GameManager.nyawa >= 3
	
	game_over.visible = GameManager.over
