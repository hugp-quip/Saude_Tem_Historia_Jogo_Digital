class_name RodadaCont extends Control


signal finished_with_win( win: bool)
signal needs_update_ui( state: PartidaRES)

var rodada_config : RodadaRES
@onready var cardHan : ControlCardHandler = get_node("CardHandler")
@onready var slotMan : ControlSlotManager = cardHan.slotMan
@onready var judge : NewRodadaJudge = get_node("RodadaJudge")
@onready var animHan : RodadaAnimationHandler = get_node("AnimationHandler")
var partida_state : PartidaRES

func criar_primeira_rodada(partidaState : PartidaRES, cartas : Array)-> void:
	rodada_config = RodadaRES.new()
	rodada_config.n_cartas = partidaState.n_cartas
	rodada_config.cards = cartas
	cardHan.iniciar(cartas)
	judge.slotMan = slotMan
	partida_state = partidaState
	rodar_inicio_animacao.call_deferred()

func _criar_rodada(cartas : Array) -> void:
	if cartas.size() != 0:
		cardHan.reiniciar(cartas)
		rodar_inicio_animacao.call_deferred()

func rodar_inicio_animacao() -> void:
	animHan.run_start_animation()

func _on_envio_pressed() -> void:
	var results = judge.get_rodada_results()
	if not (results.has_result): return

	var fb : JudgeFeedBack = Res.feedback.instantiate()
	#("resultado:", results)	
	results.correct_cards.map(func (card : ControlCard) : card.silence() )
	if results.correct_cards.size() == G.n_cartas:
		("ganhou!")
		enviar_feedback_padrao(results, fb)
		finished_with_win.emit(true)
		return
	elif partida_state.n_tentativas -1 > partida_state.tentativas_usadas:
		enviar_feedback_padrao(results, fb)
		("tente novamente!")
		partida_state.tentativas_usadas += 1
		needs_update_ui.emit(partida_state)
	else:
		("perdeu!!!")
		partida_state.tentativas_usadas += 1
		enviar_feedback_derrota(results, fb)
		finished_with_win.emit(false)
		return

func enviar_feedback_derrota(results : Dictionary, fb : JudgeFeedBack) -> void:
	results.incorrect_cards.map(func (card : ControlCard) : card.silence() )
	results.relative_correct_cards.map(func (card : ControlCard) : card.silence() )
	enviar_feedback(results.correct_cards, fb.FEEDBACK.CORRECT, "#7cfc00")
	enviar_feedback(results.incorrect_cards, fb.FEEDBACK.CORRECT, "#FF0000")
	enviar_feedback(results.relative_correct_cards, fb.FEEDBACK.CORRECT, "#cccc00")

func enviar_feedback_padrao(results : Dictionary, fb : JudgeFeedBack) -> void:
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
		
	
