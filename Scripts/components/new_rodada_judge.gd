class_name NewRodadaJudge extends Node

var slotMan : ControlSlotManager

# func can_evaluate_rodada() -> bool:
# 	return slotMan.is_table_full()

func get_rodada_results() -> Dictionary:
	var table_order : Array = slotMan.get_current_card_order()
	var ret : Dictionary = { 
		"has_result": table_order.size() > 0, 
		"correct_cards":[], "incorrect_cards":[], 
		"relative_correct_cards":[] }
	
	#print(ret)
	if not ret.has_result: return ret
	
	var correct_order : Array = slotMan.get_correct_card_order()
	#assert(false)
	#print("correct_order: "+ str(correct_order.map( func (card: CartaRES ) : return card.ano )) )
	#print("table_order: "+ str(table_order.map( func (card: ControlCard ) : return card.data.ano )) )
	var is_incorrect := func (card : ControlCard) -> bool: return card.data.id != correct_order[ table_order.find(card) ].id
	var equals := func (c1 : CartaRES, c2 : CartaRES) -> bool: return c1.ano.to_int() == c2.ano.to_int()

	var i := 0
	for card in table_order:
		if not is_incorrect.call(card):
			ret.correct_cards.append(card)
		else:
	
			var check_card_before : bool = (
				equals.call(table_order[ i - 1 ].data, 
						correct_order[ 
							correct_order.find(card.data) - 1 if correct_order.find(card.data) - 1 >= 0
							else correct_order.find(table_order[i - 1]) 
						]
					)  if i - 1 >= 0 else true
				)

			var check_card_after : bool = (
				equals.call(table_order[ i + 1 ].data,
						correct_order[ 
							correct_order.find(card.data) + 1 if correct_order.find(card.data) + 1 < correct_order.size() 
							else correct_order.find(table_order[i + 1]) 
						]
					) if i+1 < table_order.size() else true
				)
			
			# if card.data.ano.to_int() == 1928:
			# 	var card_1 =  table_order[ i - 1 ].data
			# 	var correct_1 = (correct_order[ 
			# 					correct_order.find(card.data) - 1 
			# 				])
			# 	# print("card - 1 : ", card_1.ano, " | correct - 1: ", correct_1.ano)
			# 	# print("equals: ", equals.call(card_1, correct_1) )
			# 	# print("bfr: ", check_card_before, "after: ", check_card_after)
			# 	# print("i - 1 >= 0: ", i - 1 >= 0)
			if  check_card_after and check_card_before :
				ret.relative_correct_cards.append(card)
			else:
				ret.incorrect_cards.append(card)


		i += 1
	return ret
