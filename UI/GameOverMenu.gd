extends Control

func display() -> void:
	$AnimationPlayer.play("display")

func set_score(value: int) -> void:
	$Score.set_text("Your Score:\n" + str(value))
	Globals.score = value

func _on_BackButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
