extends Area2D

@onready var hurt: AudioStreamPlayer2D = $hurt

func _on_body_entered(body: Node2D) -> void:
	hurt.playing = true
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	await get_tree().create_timer(0.6, true).timeout
	Engine.time_scale = 1
	GameManager.nyawa = 3
	GameManager.score = 0
	get_tree().reload_current_scene()
