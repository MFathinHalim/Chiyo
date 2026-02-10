extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body):
	GameManager.buffSpeed()
	animation_player.play("pickup_animation")
