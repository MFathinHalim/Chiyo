extends Area2D

@onready var hurt: AudioStreamPlayer2D = $hurt
@onready var duar: AudioStreamPlayer2D = $duar

func _on_body_entered(body: Node2D) -> void:
	if(body.is_hurt or GameManager.SPEED == 200): return
	hurt.playing = true
	body.is_hurt = true
	body.get_node("AnimatedSprite2D").play("sakit")
	if(GameManager.check_nyawa()):
		print("you died")
		duar.playing = true
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()
		await get_tree().create_timer(0.6, true).timeout
		Engine.time_scale = 1
		GameManager.nyawa = 3
		GameManager.score = 0
		get_tree().reload_current_scene()
