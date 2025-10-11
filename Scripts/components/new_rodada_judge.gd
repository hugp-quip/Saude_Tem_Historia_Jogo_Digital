class_name NewRodadaJudge extends Node

var slotMan : ControlSlotManager

# func can_evaluate_rodada() -> bool:
# 	return slotMan.is_table_full()

func get_rodada_results(already_correct_cards: Array[CartaRES]) -> Dictionary:
	var table_order : Array = slotMan.get_current_card_order()
	var ret : Dictionary = { 
		"is_old": true,
		"has_result": table_order.size() > 0, 
		"correct_cards":[], 
		"already_correct_cards" : already_correct_cards,
		"incorrect_cards":[], 
		"relative_correct_cards":[],
		"points": 0, }
	
	
	if not ret.has_result: return ret
	
	var correct_order : Array = slotMan.get_correct_card_order()
	#print("correct_order: "+ str(correct_order.map( func (card: CartaRES ) : return card.ano )) )
	#print("table_order: "+ str(table_order.map( func (card: ControlCard ) : return card.data.ano )) )
	var is_incorrect := func (card : ControlCard) -> bool: 
		return card.data.ano != correct_order[ table_order.find(card) ].ano
	# var equals := func (c1 : CartaRES, c2 : CartaRES) -> bool: return c1.ano.to_int() == c2.ano.to_int()
	

		

	var i := 0
	for card in table_order:
		if card.data in ret.already_correct_cards:
			print("card with ano: ", card.data.ano, " was already correct!")
		else:
			if not is_incorrect.call(card):
				ret.correct_cards.append(card)
			else:
		
				# var check_card_before : bool = (
				# 	equals.call(table_order[ i - 1 ].data, 
				# 			correct_order[ 
				# 				correct_order.find(card.data) - 1 if correct_order.find(card.data) - 1 >= 0
				# 				else correct_order.find(table_order[i - 1]) 
				# 			]
				# 		)  if i - 1 >= 0 else true
				# 	)

				# var check_card_after : bool = (
				# 	equals.call(table_order[ i + 1 ].data,
				# 			correct_order[ 
				# 				correct_order.find(card.data) + 1 if correct_order.find(card.data) + 1 < correct_order.size() 
				# 				else correct_order.find(table_order[i + 1]) 
				# 			]
				# 		) if i+1 < table_order.size() else true
				# 	)
				
				# if  check_card_after and check_card_before :
				# 	ret.relative_correct_cards.append(card)
				# else:
					ret.incorrect_cards.append(card)
		i += 1


	
	ret.points = _get_points_for_results(ret.correct_cards.size())
	
	#print(ret)

	return ret

func _get_points_for_results(correct_cards: int) -> int:
	return correct_cards * 200
