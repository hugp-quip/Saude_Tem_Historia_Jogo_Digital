@tool
class_name  ControlCard extends TextureButton

@onready var ui_hand : CartaControlUIHandler = get_node("Carta_Control_UI_Handler")

@export var data : CartaRES

func is_slot() -> bool:
	return !ui_hand.visible

func _ready() -> void:
	if Engine.is_editor_hint() and get_parent() is SubViewport:
		print("a")
		_load_fake_data()
	pressed.connect(click_test)

func make_slot() -> void:
	if is_slot():
		return 
	ui_hand.hide()
	get_node("TESTE").text = "ISSO AQUI É UM SLOT"

func make_card(_data: CartaRES) -> void:
	get_node("TESTE").text = ""
	ui_hand.show()
	criar_carta_display(_data)


func criar_carta_display(_data: CartaRES) -> void:
	data = _data
	updateUI(data)

func updateUI(_data: CartaRES) -> void:
	ui_hand.update(_data)



func _load_fake_data():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var r : int = rand.randi_range(0, 71) # card id
	var res : CartaRES = load("res://Resources/Cartas/"+str(r)+".res")
	data = res
	criar_carta_display(res)

func click_test():
	get_node("TESTE").text = "i was clicked!" if get_node("TESTE").text != "i was clicked!" else "you clicked me again"