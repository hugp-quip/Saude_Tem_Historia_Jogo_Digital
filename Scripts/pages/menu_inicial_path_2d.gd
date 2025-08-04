@tool
extends Path2D

@onready  var curve_size : float = curve.get_baked_length()
var follow : = load("res://Scenes/components/card_follow.tscn")

@export var n_follows : int = 5



func _ready() -> void:
	_on_menu_inicial_resized()
	var follows : Array = []
	for i in n_follows:
		var fl = follow.instantiate()
		fl.progress = 0.0
		print(i)
		fl.fullpath = curve_size
		fl.wait_time = 1.0*i
		follows.append(fl)
	
	for fl in follows:
		add_child(fl)

	

func _on_menu_inicial_resized() -> void:
	var p_size = get_parent().get_node("helper").get_rect().position
	global_position =  p_size  
