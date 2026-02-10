extends CanvasLayer
@onready var touch_control: CanvasLayer = $"."

func _ready() -> void:
	if OS.has_feature("mobile"):
		touch_control.visible = true
		print("This is a mobile device (Android or iOS)")
