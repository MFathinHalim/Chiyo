extends Area2D

@onready var hurt: AudioStreamPlayer2D = $hurt

func _on_body_entered(body: Node2D) -> void:
	hurt.playing = true
	Engine.time_scale = 0.5
	await get_tree().create_timer(0.6, true).timeout
	GameManager.over = true
