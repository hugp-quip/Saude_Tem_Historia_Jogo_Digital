class_name RodadaCont extends Control

var rodada_config : RodadaRES
@onready var cardHan : ControlCardHandler = get_node("CardHandler")
@onready var slotMan : ControlSlotManager = cardHan.slotMan
@onready var judge : NewRodadaJudge = get_node("RodadaJudge")
func criar_rodada(partidaState : PartidaRES, cartas : Array)-> void:
	rodada_config = RodadaRES.new()
	rodada_config.n_cartas = partidaState.n_cartas
	rodada_config.cards = cartas
	print(cartas)
	cardHan.iniciar(cartas)
	judge.slotMan = slotMan


func _on_envio_pressed() -> void:
	var results = judge.get_rodada_results()
	var fb : JudgeFeedBack = Res.feedback.instantiate()
	print("resultado:", results)	
	enviar_feedback(results.correct_cards, fb.FEEDBACK.CORRECT, "#7cfc00")
	enviar_feedback(results.incorrect_cards, fb.FEEDBACK.INCORRECT, "#FF0000")
	enviar_feedback(results.relative_correct_cards, fb.FEEDBACK.RELATIVE, "#cccc00")


func enviar_feedback( cards: Array, feedback_type: int ,ano_color: String ):
	for card in cards:
		var lab : Label = card.get_node("Carta_Control_UI_Handler").get_node("ano")
		lab.add_theme_color_override("font_color", Color(ano_color))
		var fb : JudgeFeedBack = Res.feedback.instantiate()
		
		lab.visible = true
		if feedback_type == fb.FEEDBACK.CORRECT: 
			lab.text = card.data.ano
		else:
			lab.text = "XXXX"
		card.add_child(fb)
		fb.criar_feedback(feedback_type)
		
	
