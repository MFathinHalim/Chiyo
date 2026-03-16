extends CharacterBody2D

signal hide_interact(sign)
signal show_interact(sign)
signal trigger_dialog(lines: Array[Dictionary])

var player: CharacterBody2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var lightning_left: AnimatedSprite2D = $"../PETIRKIRI/LightningLeft"
@onready var lightning_right: AnimatedSprite2D = $"../PETIRKANAN/LightningRight"
@onready var lighting_collision: CollisionShape2D = $"../PETIRKIRI/LightningLeft/Killzone/LightingCollision"
@onready var lighting_collision2: CollisionShape2D = $"../PETIRKANAN/LightningRight/Killzone/LightningCollision"

enum {
	IDLE,
	AIM,
	CHARGE,
	HIT_WALL,
	DIALOG,
	FINISH
}

var state = IDLE

var gravity := 1500.0
var charge_speed := 900.0

var direction := 0
var timer := 0.0
var aiming := false
var attack_count := 0
@onready var flash = get_tree().get_first_node_in_group("flash")
# 5 serangan, tiap serangan bisa punya beberapa kalimat dipisah "||"
@export var dialog_list := [
	# Format sekarang: array of dictionaries { "name": ..., "text": ... }
	[
		{ "name": "Zeus", "text": "Selamat datang!" },
		{ "name": "Zeus", "text": "Mari bermain!" }
	],
	[
		{ "name": "Zeus", "text": "HATI-HATI!" },
		{ "name": "Zeus", "text": "Aku akan menyerang" },
		{ "name": "Zeus", "text": "Cepat lari!" }
	],
	[
		{ "name": "Zeus", "text": "HAHAHA" },
		{ "name": "Zeus", "text": "Kau pikir bisa menang?" },
		{ "name": "Zeus", "text": "Jangan terlalu percaya diri!" }
	],
	[
		{ "name": "Zeus", "text": "NYERANG SEKARANG!" },
		{ "name": "Zeus", "text": "Jangan diam saja" }
	],
	[
		{ "name": "Zeus", "text": "Ini terakhir!" },
		{ "name": "Zeus", "text": "Tahan serangan terakhirku" },
		{ "name": "Zeus", "text": "Semoga berhasil!" }
	]
]
func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.register_sign(self)
	
	# pastikan dialog_list valid
	if dialog_list.size() > 0:
		attack_count = 0
		call_deferred("_start_next_dialog")
	
	lightning_left.hide()
	lightning_right.hide()
	lighting_collision.disabled = true
	lighting_collision2.disabled = true
	
func _start_next_dialog():
	if attack_count >= dialog_list.size():
		change_state(FINISH)
		return
	
	attack_count += 1
	start_dialog()

func _physics_process(delta):
	if state == DIALOG:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	timer -= delta

	match state:
		IDLE:
			velocity.x = 0
			if timer <= 0:
				change_state(AIM)

		AIM:
			velocity.x = 0
			
			if not aiming:
				aiming = true
				start_charge_sequence()

		CHARGE:
			velocity.x = direction * charge_speed
			if is_on_wall():
				change_state(HIT_WALL)

		HIT_WALL:
			velocity.x = 0
			if timer <= 0:
				attack_count += 1
				if attack_count <= dialog_list.size():
					start_dialog()
				else:
					change_state(FINISH)

		FINISH:
			velocity = Vector2.ZERO
	
	var posisi_player = (player.global_position - global_position).normalized()
	if posisi_player.x > 0:
		sprite.flip_h = false
	elif posisi_player.x < 0:
		sprite.flip_h = true

	move_and_slide()

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			timer = 1.5
			sprite.play("idle")
		AIM:
			timer = 0.7
			sprite.play("warn")
		CHARGE:
			sprite.play("charge")
			pass
		HIT_WALL:
			timer = 0.4
			sprite.play("idle")
		DIALOG:
			velocity = Vector2.ZERO
			sprite.play("idle")

		FINISH:
			velocity = Vector2.ZERO
			sprite.play("tired")

func start_dialog():
	change_state(DIALOG)

	var raw_lines = dialog_list[attack_count - 1]
	var lines: Array[Dictionary] = []

	for item in raw_lines:
		lines.append(item as Dictionary)  # pastiin tiap element dicast Dictionary

	trigger_dialog.emit(lines)
	
func resume_attack():
	if attack_count <= dialog_list.size():
		change_state(IDLE)
		
	
func lightning_attack():
	lightning_left.visible = true
	lightning_right.visible = true
	lighting_collision.disabled = false
	lighting_collision2.disabled = false
	lightning_left.play("strike")
	lightning_right.play("strike")

	await lightning_left.animation_finished
	lightning_left.visible = false
	lightning_right.visible = false
	lighting_collision.disabled = true
	lighting_collision2.disabled = true
	
func start_charge_sequence():
	await lightning_warning_flash()
	await lightning_attack()

	await get_tree().create_timer(0.6).timeout

	if player:
		direction = sign(player.global_position.x - global_position.x)

	aiming = false
	change_state(CHARGE)
	
func lightning_warning_flash():

	for i in 3:
		flash.modulate.a = 0.8
		await get_tree().create_timer(0.07).timeout

		flash.modulate.a = 0.0
		await get_tree().create_timer(0.07).timeout
