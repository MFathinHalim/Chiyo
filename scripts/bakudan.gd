extends CharacterBody2D

const SPEED = 200
const GRAVITY = 900
@export var chase_radius := 80.0
@onready var explosion: GPUParticles2D = $ExplosionParticles
var player: CharacterBody2D
var chasing := false
@onready var hurt: AudioStreamPlayer2D = $hurt
@onready var duar: AudioStreamPlayer2D = $duar

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction := 0
func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):

	if player == null:
		return

	# gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0

	var distance = global_position.distance_to(player.global_position)
	# mulai mengejar kalau player dekat
	if distance < chase_radius and not chasing:
		chasing = true
		direction = sign(player.global_position.x - global_position.x)
	
	if chasing:
		velocity.x = direction * SPEED
		animated_sprite.play("attack")
			
		if is_on_wall():
			explode()
	else:
		velocity.x = 0

	move_and_slide()

		
func _on_hitbox_body_entered(body: Node2D) -> void:
	if(body.name == "player" or is_on_wall()):
		print("test")
		if body.name == "player":
			if(!body.is_hurt or GameManager.SPEED == 200):
				body.is_hurt = true
				if(GameManager.check_nyawa()):
					body.mati = true
					print("you died")
					body.get_node("AnimatedSprite2D").play("dead")
					Engine.time_scale = 0.5
					await get_tree().create_timer(0.6, true).timeout
					GameManager.over = true
		explode()

func explode():
	duar.playing = true
	velocity.x = 0
	set_physics_process(false)
	velocity = Vector2.ZERO

	animated_sprite.hide()

	explosion.emitting = true

	await get_tree().create_timer(explosion.lifetime).timeout
	print(explosion.emitting)

	queue_free()
