@tool
class_name  ControlCard extends TextureButton

signal has_mouse(card: ControlCard)
signal lost_mouse(card: ControlCard)

@onready var ui_hand : CartaControlUIHandler = get_node("Carta_Control_UI_Handler")

@export var data : CartaRES
var draggable : bool = true

func is_slot() -> bool:
	return data == null

func _ready() -> void:
	if Engine.is_editor_hint() and get_parent() is SubViewport and false:
		("a")
		_load_fake_data()

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


func _on_mouse_exited() -> void:
	lost_mouse.emit(self)
