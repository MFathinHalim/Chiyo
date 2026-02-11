extends CharacterBody2D


@onready var jump: AudioStreamPlayer2D = $jump
@onready var tap: AudioStreamPlayer2D = $tap

var total_jump = 0
var is_hurt = false

var air_dash_count = 0
const MAX_AIR_DASH = 2
var is_dashing := false
var dash_timer := 0.0

const DASH_SPEED := 600
const DASH_TIME := 0.15
var mati = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
	
func _physics_process(delta: float) -> void:
	if not GameManager.over: 
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("move_left", "move_right")
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and total_jump < 4:
			if total_jump == 0:
				jump.playing = true
			else:
				tap.playing = true
			
			if total_jump < 1:
				velocity.y = GameManager.JUMP_VELOCITY
			
			if total_jump >= 1 and not is_dashing and air_dash_count < MAX_AIR_DASH:
				_start_dash(direction)
			
			total_jump += 1

		if direction == 1:
			animated_sprite.flip_h = false
		elif direction == -1.0:
			animated_sprite.flip_h = true
		
		#Player animation
		if(is_hurt):
			if(mati):
				animated_sprite.play("dead")
			else:			
				animated_sprite.play("sakit")
				is_hurt = false
		
		elif is_on_floor() and not is_hurt:
			total_jump = 0
			air_dash_count = 0
			if direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			if air_dash_count > 0: animated_sprite.play("dash")
			else: animated_sprite.play("jump")
		
		if is_dashing:
			velocity.x = DASH_SPEED * direction
			dash_timer += delta
			if dash_timer >= DASH_TIME:
				is_dashing = false
				dash_timer = 0
		else:
			if direction:
				velocity.x = direction * GameManager.SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, GameManager.SPEED)
			
		if GameManager.SPEED == 200:
			animated_sprite.speed_scale = 50
		else:
			animated_sprite.speed_scale = 1
		move_and_slide()

func _start_dash(dir: int) -> void:
	is_dashing = true
	air_dash_count += 1
	velocity.y = 0
