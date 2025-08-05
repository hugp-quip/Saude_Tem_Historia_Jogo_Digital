class_name RodadaAnimationHandler extends Control

@onready var rodCont : RodadaCont = get_parent()
@onready var animCards : Array = get_children()
var cardHan : ControlCardHandler
var slotMan : ControlSlotManager
var slot_example : ControlCard
var cardsToMove : Array[Dictionary]
var card_home : Vector2 = Vector2(55, -390)

func _ready() -> void:
	get_siblings.call_deferred()

func get_siblings() -> void:
	cardHan = rodCont.cardHan
	slotMan = rodCont.slotMan
	slot_example = slotMan.table_slots[0] 

func run_start_animation():
	var hand_slots : = slotMan.hand_slots
	var times : Array[float] = []
	for i in hand_slots.size():
		animCards[i].make_card(hand_slots[i].data)
		animCards[i].size = slot_example.get_global_rect().size
		hand_slots[i].make_slot()
		times.append(0.5+0.2*i)
		cardsToMove.append( 
			{ 
			  "card": animCards[i], 
			  "slot": hand_slots[i],
			  "goal": hand_slots[i].get_global_rect().position + Vector2(0, 100),
			  "wait_time":times[i],
			  "start": false,
			  "end" : false,
			}
		)
	for i in animCards.size():
		animCards[i].get_node("Start_Timer").one_shot = true
		animCards[i].get_node("Start_Timer").timeout.connect(start_moving_after_timeout.bind(i))
		animCards[i].get_node("Start_Timer").start(times[i]) 

func start_moving_after_timeout(card_index : int):
	cardsToMove[card_index].start = true
	
func _physics_process(delta: float) -> void:
	move_cards(cardsToMove, delta)

func move_cards(card_to_move : Array[Dictionary], _delta : float) -> void:
	for data : Dictionary in card_to_move:
		if data.start and not data.end:
			#data.card.global_position = util.move_toward_vect(data.card.get_global_rect().position, data.goal, delta*240) 
			data.card.global_position = data.card.global_position.lerp(data.goal, 0.03)
		if not (data.end) and ceilf(data.card.get_global_rect().position.y) >= (data.goal.y - 100.0):
			#data.card.global_position = data.goal
			data.slot.make_card(data.card.data)
			data.card.position = card_home
			data.end = true
			card_to_move.remove_at(card_to_move.find(data))
