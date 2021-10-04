extends Control

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		if get_tree().paused:
			show()
		else:
			hide()

func _on_ContinueButton_pressed():
	hide()
	get_tree().paused = false

func _on_ExitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://MainMenu.tscn")
