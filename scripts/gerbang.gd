extends Node

func _on_body_entered(body: Node2D) -> void:
	print("hello")
	if GameManager.score >= GameManager.total:
		get_tree().change_scene_to_file("res://scenes/win.tscn")
