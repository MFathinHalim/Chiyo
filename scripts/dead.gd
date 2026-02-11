extends CanvasLayer

func _on_restart_button_down() -> void:
	Engine.time_scale = 1
	GameManager.nyawa = 3
	GameManager.score = 0
	GameManager.SPEED = 130
	GameManager.JUMP_VELOCITY = -300
	GameManager.over = false
	get_tree().reload_current_scene()
	


func _on_quit_button_down() -> void:
	OS.shell_open("https://www.youtube.com/watch?v=e3YcYLE90po")
	get_tree().quit()
