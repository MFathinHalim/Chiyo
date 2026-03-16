extends CharacterBody2D

@onready var jump: AudioStreamPlayer2D = $jump
@onready var tap: AudioStreamPlayer2D = $tap
@onready var text_box = %TextBox/TextboxContainer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_reset_timer: Timer = $JumpResetTimer
@onready var debu: GPUParticles2D = $DebuParticles

var total_jump := 0
var is_hurt := false

var air_dash_count := 0
const MAX_AIR_DASH := 2

var is_dashing := false
var dash_timer := 0.0

const DASH_SPEED := 600.0
const DASH_TIME := 0.15

var mati := false
var lagiNgomong := false

func _physics_process(delta: float) -> void:
	
	lagiNgomong = text_box and text_box.visible
	
	if GameManager.over:
		return
	
	var direction := Input.get_axis("move_left", "move_right")
	
	
	# ======================
	# GRAVITY (SELALU ADA)
	# ======================
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	# ======================
	# KALAU LAGI NGOMONG
	# ======================
	if lagiNgomong:
		# Stop gerakan horizontal
		velocity.x = 0
		
		# Cancel dash kalau lagi dash
		is_dashing = false
		dash_timer = 0.0
	
	else:
		# ======================
		# INPUT NORMAL
		# ======================
		debu.emitting = false
		

		if Input.is_action_just_pressed("jump"):
			if total_jump == 0:
				debu.emitting = true
				velocity.y = GameManager.JUMP_VELOCITY
				total_jump += 1
				jump_reset_timer.start()
			elif total_jump == 1:
				debu.emitting = true
				velocity.y = GameManager.JUMP_VELOCITY
				total_jump += 1
			elif total_jump > 1 and air_dash_count < MAX_AIR_DASH:
				_start_dash(direction)
		if not is_dashing:
			if direction != 0:
				if(is_on_floor()):
					debu.emitting = true
				velocity.x = direction * GameManager.SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, GameManager.SPEED)
	

	# ======================
	# DASH TIMER
	# ======================
	if is_dashing:
		dash_timer += delta
		if dash_timer >= DASH_TIME:
			is_dashing = false
			dash_timer = 0.0
	
	
	# ======================
	# MOVE SELALU DIPANGGIL
	# ======================
	move_and_slide()
	
	
	# ======================
	# RESET SAAT LANDING
	# ======================
	if is_on_floor():
		total_jump = 0
		air_dash_count = 0
	
	# ========================
	# FLIP SPRITE
	# ========================
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	
	# ========================
	# ANIMATION SYSTEM
	# ========================
	if is_hurt:
		if mati:
			animated_sprite.play("dead")
		else:
			animated_sprite.play("sakit")
			is_hurt = false
	
	elif is_on_floor():
		if direction == 0 or lagiNgomong:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	
	else:
		if is_dashing:
			animated_sprite.play("dash")
		else:
			animated_sprite.play("jump")
	
	
	# ========================
	# SPEED SCALE FIX
	# ========================
	if GameManager.SPEED == 200:
		animated_sprite.speed_scale = 50
	else:
		animated_sprite.speed_scale = 1


func _start_dash(dir: float) -> void:
	if dir == 0:
		return
	
	is_dashing = true
	air_dash_count += 1
	velocity.y = 0
	velocity.x = DASH_SPEED * dir
