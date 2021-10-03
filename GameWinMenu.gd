extends Control

func display() -> void:
	$AnimationPlayer.play("display")

func set_score(value: int) -> void:
	$Score.set_text("Your Score:\n" + str(value))
	$FinalScore.set_text("Final Score:\n" + str(value*2))

func _on_BackButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
