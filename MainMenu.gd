extends Node2D

func _ready():
	$TitleTheme.play()
	Globals.score = 0
	Globals.load_data()
	if Globals.high_score > 0:
		$HighScore.set_text("High Score: " + str(Globals.high_score))

func _on_StartButton_pressed():
	get_tree().change_scene("res://InstructionsMenu.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()
