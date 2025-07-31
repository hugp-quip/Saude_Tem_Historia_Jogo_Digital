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
	
	print(ret)
	if not ret.has_result: return ret
	
	var correct_order : Array = slotMan.get_correct_card_order()
	#assert(false)
	print("correct_order: "+ str(correct_order.map( func (card: CartaRES ) : return card.ano )) )
	print("table_order: "+ str(table_order.map( func (card: ControlCard ) : return card.data.ano )) )
	var is_incorrect := func (card : ControlCard) -> bool: return card.data.id != correct_order[ table_order.find(card) ].id
	var greater_than := func (c1, c2) -> bool: return c1.data.ano.to_int() > c2.data.ano.to_int()

	var i := 0
	for card in table_order:
		if not is_incorrect.call(card):
			ret.correct_cards.append(card)
		else:
			var check_card_before : bool = (greater_than.call(card, table_order[ i - 1 ])  if i-1 > 0 else false)
			var check_card_after : bool = (greater_than.call(table_order[ i + 1 ], card) if i+1 < table_order.size() else false)
			print(i)
			
			if  check_card_after and check_card_before :
				ret.relative_correct_cards.append(card)
			else:
				ret.incorrect_cards.append(card)


		i += 1
	return ret
