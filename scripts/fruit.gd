extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body):
	if(GameManager.nyawa > 1 and GameManager.nyawa < 3):
		GameManager.add_nyawa()
		animation_player.play("pickup_animation")
