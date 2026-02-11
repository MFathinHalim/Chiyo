extends Node

var score = 0
var total = 0
var nyawa = 3
var SPEED = 130.0
var JUMP_VELOCITY = -300.0

func add_point():
	score += 1
	
func add_nyawa():
	if(nyawa > 1 and nyawa < 3):
		nyawa += 1

func check_nyawa() -> bool:
	nyawa -= 1
	return nyawa <= 0

func buffSpeed():
	SPEED = 200
	JUMP_VELOCITY = -400
	await get_tree().create_timer(5, true).timeout
	SPEED = 130.0
	JUMP_VELOCITY = -300
