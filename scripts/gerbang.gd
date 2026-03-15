extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var terbuka = false
func _process(delta: float) -> void:
	if GameManager.score >= GameManager.total:
		terbuka = true
		animated_sprite_2d.play("terbuka")

func _on_body_entered(body: Node2D) -> void:
	if terbuka:
		GameManager.score -= GameManager.total
		var cutscene = preload("res://scenes/cutscene.tscn").instantiate()
		get_tree().root.add_child(cutscene)

		var bg: Texture2D
		var dialog_lines: Array[String]
		var next_scene: String

		var current_scene_name = get_tree().current_scene.name
		print(current_scene_name)
		if current_scene_name == "level1":
			bg = preload("res://assets/cutscenes/cutscenetest.jpg")
			dialog_lines = [
				"Ini awal perjalanan...",
				"Semuanya terlihat tenang."
			]
			next_scene = "res://scenes/levels/level2.tscn"

		cutscene.play_cutscene(bg, dialog_lines, next_scene)
