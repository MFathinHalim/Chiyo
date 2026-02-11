extends Area2D

@onready var hurt: AudioStreamPlayer2D = $hurt
@onready var duar: AudioStreamPlayer2D = $duar

func _on_body_entered(body: Node2D) -> void:
	if(body.is_hurt or GameManager.SPEED == 200): return
	hurt.playing = true
	body.is_hurt = true
	if(GameManager.check_nyawa()):
		body.mati = true
		print("you died")
		duar.playing = true
		body.get_node("AnimatedSprite2D").play("dead")
		Engine.time_scale = 0.5
		await get_tree().create_timer(0.6, true).timeout
		GameManager.over = true
