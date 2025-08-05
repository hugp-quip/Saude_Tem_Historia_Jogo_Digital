extends Label

#@onready var camera : Camera2D = get_parent().get_node("Camera2D")

func _ready() -> void:
	self.text = "screen_size: " + str(get_viewport_rect().size)
