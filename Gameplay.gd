extends Node2D

const BIG_ASTEROIDS = [
	preload("res://Asteroids/BigAsteroid01.tscn")
]

const SMALL_ASTEROIDS = [
	preload("res://Asteroids/SmallAsteroid01.tscn")
]

const OUTER_BELT_RADIUS = 4500
const MIDDLE_BELT_RADIUS = 3000
const INNER_BELT_RADIUS = 1200

onready var game_win_menu = $UI/CenterContainer/GameWinMenu
onready var game_over_menu = $UI/CenterContainer/GameOverMenu
onready var pause_menu = $UI/CenterContainer/PauseMenu
onready var animation_player = $AnimationPlayer
onready var text_animation_player = $TextAnimationPlayer
onready var score_label = $UI/ScoreLabel
onready var player = $Player
onready var warp_point = $WarpPoint
onready var warning_label = $UI/Warning

onready var score = 0

func _ready():
	randomize()
	game_win_menu.hide()
	game_over_menu.hide()
	pause_menu.hide()
	warning_label.hide()
	set_score(0)
	randomize_player_spawn()
	generate_asteroid_belt()

# Spawn next to the middle asteroid belt at a random angle
func randomize_player_spawn():
	var angle = rand_range(0, 360)
	var radius = MIDDLE_BELT_RADIUS - 400
	var spawn_pos = Vector2(radius, 0).rotated(deg2rad(angle))
	player.global_position = spawn_pos
	warp_point.global_position = spawn_pos

# Asteroid belt is made up of small asteroids and a few big asteroids
func generate_asteroid_belt():
	# Middle belt
	for i in range(0, 360, 9):
		for j in range(3):
			if randf() <= 0.2:
				continue
			var choice
			var asteroid
			if randf() <= 0.2:
				choice = randi() % BIG_ASTEROIDS.size()
				asteroid = BIG_ASTEROIDS[choice].instance()
			else:
				choice = randi() % SMALL_ASTEROIDS.size()
				asteroid = SMALL_ASTEROIDS[choice].instance()
			var radius = MIDDLE_BELT_RADIUS + rand_range(-128, 128) + j * 256
			var angle = deg2rad(i) + j * 17
			var spawn_pos = Vector2(radius, 0).rotated(deg2rad(i))
			spawn_pos += Vector2(rand_range(-128, 128), rand_range(-128, 128))
			asteroid.global_position = spawn_pos
			add_child(asteroid)
	
	# Inner belt, more sparse
	for i in range(0, 360, 20):
		if randf() <= 0.4:
			continue
		var choice = randi() % SMALL_ASTEROIDS.size()
		var asteroid = SMALL_ASTEROIDS[choice].instance()
		var radius = INNER_BELT_RADIUS + rand_range(-64, 64)
		var angle = deg2rad(i) + rand_range(-8, 8)
		var spawn_pos = Vector2(radius, 0).rotated(deg2rad(i))
		spawn_pos += Vector2(rand_range(-128, 128), rand_range(-128, 128))
		asteroid.global_position = spawn_pos
		add_child(asteroid)
	
	# Outer belt, sparse, big asteroids only
	for i in range(0, 360, 20):
		if randf() <= 0.3:
			continue
		var choice = randi() % BIG_ASTEROIDS.size()
		var asteroid = BIG_ASTEROIDS[choice].instance()
		var radius = OUTER_BELT_RADIUS + rand_range(-64, 64)
		var angle = deg2rad(i) + rand_range(-8, 8)
		var spawn_pos = Vector2(radius, 0).rotated(deg2rad(i))
		spawn_pos += Vector2(rand_range(-128, 128), rand_range(-128, 128))
		asteroid.global_position = spawn_pos
		add_child(asteroid)

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

func _on_Star_unstable():
	warning_label.show()
	text_animation_player.play("warning")

func _on_Star_exploded():
	text_animation_player.queue("black_hole_warning")
	warning_label.set_text("A BLACK HOLE HAS FORMED!")
