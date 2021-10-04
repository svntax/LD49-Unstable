extends Node

var score = 0
var high_score = 0

func _ready():
	load_data()

func save_data():
	var file = File.new()
	var err = file.open("user://save_game.dat", File.WRITE)
	if err == OK:
		file.store_line(str(high_score))
		file.close()

func load_data():
	var file = File.new()
	if not file.file_exists("user://save_game.dat"):
		return
	
	var err = file.open("user://save_game.dat", File.READ)
	if err == OK:
		var content = file.get_line()
		high_score = int(content)
		file.close()

func update_high_score() -> bool:
	if score > high_score:
		high_score = score
		return true
	return false
