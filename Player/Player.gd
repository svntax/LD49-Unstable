extends Area2D

enum States {NORMAL, DEAD}
onready var state = States.NORMAL

const MAX_SPEED = 360
const MAX_TURN_SPEED = 120 # degrees
const TURN_SPEED = 180 # degrees
const SLOW_DOWN_RATE = 2

signal died()

onready var velocity = Vector2()
onready var acceleration = Vector2()
onready var pull_force = Vector2()
onready var turn_velocity = 0
onready var flying_speed = 8

func _ready():
	pass

func _process(delta):
	if _can_move():
		turn_velocity = 0
		if Input.is_action_pressed("ui_left"):
			turn_velocity += -TURN_SPEED * delta
		if Input.is_action_pressed("ui_right"):
			turn_velocity += TURN_SPEED * delta
		
		# Slowly pulled towards black holes
		var net_force = Vector2.ZERO
		for black_hole in get_tree().get_nodes_in_group("black_holes"):
			var angle = black_hole.global_position.angle_to_point(global_position)
			var dist = global_position.distance_to(black_hole.global_position)
			var magnitude = black_hole.get_pull_magnitude() + 8 * (1 - min(1, (dist / (black_hole.size * 600.0))))
			net_force += Vector2(magnitude, 0).rotated(angle)
		pull_force = net_force
		
		acceleration = Vector2.ZERO
		if Input.is_action_pressed("ui_up"):
			acceleration += Vector2(flying_speed, 0).rotated(rotation)
		if Input.is_action_pressed("ui_down"):
			acceleration -= Vector2(flying_speed, 0).rotated(rotation)

func _physics_process(delta):
	if _can_move():
		position += velocity * delta
		velocity += acceleration + pull_force
		rotate(deg2rad(turn_velocity))
	
	velocity = velocity.clamped(MAX_SPEED)
	
	# Slow down to a stop
	velocity = lerp(velocity, Vector2.ZERO, 0.01)

func _can_move() -> bool:
	return state == States.NORMAL

func die() -> void:
	state = States.DEAD
	hide()
	emit_signal("died")

func consume() -> void:
	die()
