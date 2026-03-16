extends Line2D

var queue: Array = []
@export var MAX_LENGTH: int = 10

func _ready():
	top_level = true

func _process(_delta):
	var pos = get_parent().global_position

	queue.push_front(pos)

	if queue.size() > MAX_LENGTH:
		queue.pop_back()

	points = queue
