extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# ==========================
# Player & history
# ==========================
var player: CharacterBody2D
var position_history := []
var delay_frames := 0           # frame delay mirror
var follow_speed := 500          # kecepatan horizontal mirror
var vertical_smooth := 0.2       # smoothing vertical

# ==========================
# Slide awal ke posisi start player
# ==========================
var slide_start := true
var slide_speed := 150.0
var player_start_pos: Vector2

# ==========================
# Recording pergerakan
# ==========================
var last_recorded_pos: Vector2
var record_threshold := 1.0       # minimal perubahan posisi untuk dicatat
var record_interval := 0.016      # ~60fps
var record_timer := 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player:
		player_start_pos = player.global_position
		last_recorded_pos = player.global_position

func _physics_process(delta):
	if player == null:
		return

	# ==========================
	# RECORD PLAYER POSITION
	# ==========================
	record_timer += delta
	if record_timer >= record_interval or player.global_position.distance_to(last_recorded_pos) > record_threshold:
		position_history.append(player.global_position)
		last_recorded_pos = player.global_position
		record_timer = 0.0

	# ==========================
	# SLIDE AWAL KE POSISI START PLAYER
	# ==========================
	if slide_start:
		var dir_x = player_start_pos.x - global_position.x
		if abs(dir_x) > 1:
			velocity.x = clamp(dir_x * 10, -slide_speed, slide_speed)
		else:
			velocity.x = 0
			slide_start = false  # slide selesai, mulai mirror

		# vertical slide ke posisi start player
		global_position.y = lerp(global_position.y, player_start_pos.y, vertical_smooth)

		move_and_slide()
		update_animation()
		return

	# ==========================
	# TUNGGU HISTORY CUKUP
	# ==========================
	if position_history.size() <= delay_frames:
		velocity.x = 0
		return

	# ==========================
	# AMBIL TARGET POS DENGAN DELAY
	# ==========================
	var target_pos = position_history.pop_front()

	# ==========================
	# HORIZONTAL FOLLOW
	# ==========================
	var dir_x = target_pos.x - global_position.x
	if abs(dir_x) > 1:
		velocity.x = clamp(dir_x * 10, -follow_speed, follow_speed)
	else:
		velocity.x = 0

	# ==========================
	# VERTICAL FOLLOW (smooth)
	# ==========================
	global_position.y = lerp(global_position.y, target_pos.y, vertical_smooth)

	move_and_slide()
	update_animation()

func update_animation():
	# flip sprite
	if velocity.x > 5:
		sprite.flip_h = true
	elif velocity.x < -5:
		sprite.flip_h = false

	# animasi
	if abs(global_position.y - player.global_position.y) > 1:
		sprite.play("jump")
	elif abs(velocity.x) > 5:
		sprite.play("run")
	else:
		sprite.play("idle")
