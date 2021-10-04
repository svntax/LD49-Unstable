extends Node2D

onready var page00 = $Page00
onready var page01 = $Page01
onready var page02 = $Page02
onready var start_button = $StartButton

onready var current_page = 0

func _ready():
	page00.show()
	page01.hide()
	page02.hide()
	start_button.set_text("Next")

func _on_StartButton_pressed():
	if current_page == 0:
		page00.hide()
		page01.show()
	elif current_page == 1:
		page01.hide()
		page02.show()
		start_button.set_text("Start")
	elif current_page == 2:
		get_tree().change_scene("res://Gameplay.tscn")
	current_page += 1
