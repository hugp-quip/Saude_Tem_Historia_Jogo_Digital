extends Control

var slotMan : SlotManager 
var aniHan : RodadaAnimationHandler
var aniHan_scale : Vector2 
# @export var hand : Node2D
# @export var table : Node2D

# var control_hand : Control
# var control_table : Control
var control_slotMan : Control

func _ready():
	start.call_deferred()

func start():
	aniHan = get_parent().get_parent().animHan
	aniHan_scale = aniHan.scale
	slotMan = get_parent().get_parent().slotMan
	# control_hand = get_node("Hand")
	# control_table = get_node("Table")
	control_slotMan = get_node("SlotManager")
	# control_hand.position_change.connect(_on_table_resized)
	# control_table.position_change.connect(_on_table_resized)
	
	# table = slotMan.get_node("Table")
	# hand = slotMan.get_node("Hand")
	_on_resized()

# func _physics_process(_delta: float) -> void:
# 	_on_table_resized()





func _on_resized() -> void:
	if aniHan == null:
		_on_resized.call_deferred()
	else:
		aniHan.scale = scale*aniHan_scale
		slotMan.global_position = control_slotMan.position#util.get_position_from_control_to_node2D(control_slotMan.get_global_rect())
		slotMan.align_cards()
		
