class_name JudgeFeedBack extends TextureRect

var deathT : Timer

func _ready():
	deathT = get_node("DeathTimer")
	deathT.start(0.8)

enum FEEDBACK{
	CORRECT,
	INCORRECT,
	RELATIVE,
}

func criar_feedback( _feedback: int) -> void:
	#(FEEDBACK)
	match _feedback:
		FEEDBACK.CORRECT:
			self.texture = Res.feed_back_correct
		FEEDBACK.INCORRECT:
			self.texture = Res.feed_back_error
		FEEDBACK.RELATIVE:
			self.texture = Res.feed_back_almost

	self.position = get_parent().global_position 
	self.position.x += get_parent().size.x/2 - size.x/2
	self.position.y += get_parent().size.y/2 - size.y/2

func _physics_process(_delta: float) -> void:
	position.y -= 4*_delta*60

func _on_death_timer_timeout() -> void:
	queue_free()