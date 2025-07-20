extends Label

@onready var camera : Camera2D = get_parent().get_node("Camera2D")

func _ready() -> void:
	get_viewport().size_changed.connect(on_size_changed)
	self.text = str(get_viewport_rect())

func on_size_changed():
	var temp := get_viewport_rect()
	camera.global_position = temp.position
	self.text = str(temp.position)
