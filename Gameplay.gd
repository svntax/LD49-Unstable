extends Node2D

onready var game_over_menu = $UI/CenterContainer/GameOverMenu
onready var animation_player = $AnimationPlayer

func _ready():
	game_over_menu.hide()

func game_over() -> void:
	animation_player.play("game_over")
	game_over_menu.set_score(123)

func _on_Player_died():
	game_over()
