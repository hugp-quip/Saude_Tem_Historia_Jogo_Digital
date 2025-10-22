@tool
class_name  ControlCard extends TextureButton

signal has_mouse(card: ControlCard)
signal lost_mouse(card: ControlCard)

@onready var ui_hand : CartaControlUIHandler = get_node("Carta_Control_UI_Handler")

@export var data : CartaRES
var draggable : bool = true

func is_slot() -> bool:
	return data == null

# func _ready() -> void:
# 	if Engine.is_editor_hint() and get_parent() is SubViewport and false:
# 		("a")
# 		_load_fake_data()

func make_slot() -> void:
	if not ui_hand.visible:
		return 
	data = null
	ui_hand.clear()
	draggable = true
	ui_hand.hide()

func silence() -> void:
	draggable = false

func reveal_ano() -> void:
	ui_hand.ano.show()
	ui_hand.ano.text = data.ano

func hide_ano() -> void:
	ui_hand.ano.hide()
	

func make_card(_data: CartaRES) -> void:
	ui_hand.show()
	ui_hand.clear()
	criar_carta_display(_data)


func criar_carta_display(_data: CartaRES) -> void:
	data = _data
	updateUI(data)

func updateUI(_data: CartaRES) -> void:
	ui_hand.update(_data)

func _load_fake_data():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	#var r : int = rand.randi_range(0, 71) # card id
	var res : CartaRES = util.random_card_res()#load("res://Resources/Cartas/"+str(r)+".res")
	data = res
	criar_carta_display(res)

func _on_mouse_entered() -> void:
	has_mouse.emit(self)
	is_mouse_inside = true



func _on_mouse_exited() -> void:
	lost_mouse.emit(self)
	is_mouse_inside = false
	#setNormalState()



@export var exit_tween_duration: float = 0.3
var is_dragging : bool = false
var initial_position_of_drag  : Vector2 = Vector2()
var current_position_of_drag : Vector2 = Vector2()
var is_mouse_inside : bool
var exit_tween : Tween

func _ready() -> void:
	set_process_input(true)

# func _input(event):
# 	if event is InputEventMouseMotion and !is_slot() and is_mouse_inside:
# 		if !is_dragging: 
# 			return

		# print("make timer")
		# await get_tree().create_timer(0.1).timeout
		# _call_after_time()

#func _call_after_time():
		
		
		#divide by scale to make independant of scale
		#subtract by size/2.0 to center the mouse pos

func _physics_process(_delta):
	if is_dragging:
		initial_position_of_drag = get_mouse_pos()
		update_shader()

func get_mouse_pos():
	return get_global_mouse_position() - global_position

func update_shader():
		var mouse_position =  position - initial_position_of_drag 
		var relative_mouse_position = mouse_position #- global_position
		var centred_mouse_postion = relative_mouse_position/scale - size/2.0
		material.set_shader_parameter("_mousePos", centred_mouse_postion)
	
#go back to original state with ease out
func setNormalState():
	if exit_tween and exit_tween.is_valid():
		exit_tween.kill()
	exit_tween = get_tree().create_tween()
	exit_tween.tween_property(material, "shader_parameter/_mousePos", Vector2.ZERO, exit_tween_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
