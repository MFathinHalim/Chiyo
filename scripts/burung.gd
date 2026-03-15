extends CharacterBody2D

const SPEED = 140
const CHASE_RADIUS = 80.0

var player: CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):

	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * SPEED

	# hanya ngejar kalau player dekat
	if distance < CHASE_RADIUS:
		move_and_slide()


	# flip sprite
	if velocity.x > 0:
		animated_sprite.flip_h = true
	elif velocity.x < 0:
		animated_sprite.flip_h = false
