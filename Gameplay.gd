extends Node2D

onready var game_win_menu = $UI/CenterContainer/GameWinMenu
onready var game_over_menu = $UI/CenterContainer/GameOverMenu
onready var pause_menu = $UI/CenterContainer/PauseMenu
onready var animation_player = $AnimationPlayer
onready var score_label = $UI/ScoreLabel

onready var score = 0

func _ready():
	game_win_menu.hide()
	game_over_menu.hide()
	pause_menu.hide()
	set_score(0)

func add_score(value: int) -> void:
	set_score(score + value)

func set_score(value: int) -> void:
	score = value
	score_label.set_text("Score: " + str(value))

func game_win() -> void:
	pause_menu.set_process(false)
	animation_player.play("game_win")
	game_win_menu.set_score(score)
	if Globals.update_high_score():
		Globals.save_data()

func game_over() -> void:
	pause_menu.set_process(false)
	animation_player.play("game_over")
	game_over_menu.set_score(score)
	if Globals.update_high_score():
		Globals.save_data()

func _on_Player_died():
	game_over()

func _on_Player_escaped():
	game_win()
