@tool
extends Node

const carta_size : Vector2 = Vector2(404.0, 572.0) 
@onready var random : RandomNumberGenerator = RandomNumberGenerator.new()	

func _ready():
	random.randomize()

func stop() -> void:
	push_error("UTIL HAS STOPPED PROGRAM!!!")
	assert(false)

func random_card_res():
	var r : int = random.randi_range(0, 71)
	var res : CartaRES = load("res://Resources/Cartas/"+str(r)+".res")
	return res

# if already has scale do get_rect*scale to old_size
func scale_to_same_size(reference_size : Vector2, old_size : Vector2) -> Vector2:
	#print(str(reference_size) + "/" + str(old_size))
	#print(Vector2(reference_size.x/old_size.x , reference_size.y/old_size.y))
	return Vector2(reference_size.x/old_size.x , reference_size.y/old_size.y)

func get_carta_size(reference : Node) -> Vector2:
	#print(reference.get_viewport().get_visible_rect())
	return Vector2(reference.get_viewport().get_visible_rect().size.x/7, get_viewport().get_visible_rect().size.y/3)

func get_size(node : Sprite2D) ->  Vector2:
	return node.get_rect().size * node.global_scale

func get_position_from_control_to_node2D(controlP: Rect2) -> Vector2:
	return Vector2(controlP.position.x + controlP.size.x, controlP.position.y + controlP.size.y )

func printn(parent: Object, name: Variant, add_name: bool = false) -> void:
	if parent == null:
		push_error("parent is null on util.printn: " + name)
		return
	var parent_name : String = parent.name + "." if add_name else ""
	# if name is String, then it's an atribute
	if name is String:
		print( parent_name + name + ": " + str(parent[name]))
	# if not it's a method
	elif name is Callable:
		var result = parent.callv(name.get_method(), name.get_bound_arguments())
		print(parent_name + name.get_method() + "( "+ str(name.get_bound_arguments()).right(-1).left(-1) + " ): " + ("\""+str(result)+"\"") if result is String else result)
	else:
		push_error("util.printn didn't find a valid name.")
		return
