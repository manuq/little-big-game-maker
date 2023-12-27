extends CanvasLayer

signal half_transition_completed

func transition():
	%AnimationPlayer.play("transition_in")
	await %AnimationPlayer.animation_finished
	half_transition_completed.emit()
	%AnimationPlayer.play("transition_out")
	await %AnimationPlayer.animation_finished
	queue_free()
