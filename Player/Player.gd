extends Area2D

enum States {NORMAL, DEAD, FINISHED}
onready var state = States.NORMAL

const MAX_SPEED = 360
const MAX_TURN_SPEED = 120 # degrees
const TURN_SPEED = 180 # degrees
const SLOW_DOWN_RATE = 2
const REFUEL_RATE = 20 # units / second
const FUEL_LOSS_RATE = 2 # units / second

signal escaped()
signal died()

onready var fuel_bar = $UI/FuelBar
onready var laser = $Laser

onready var velocity = Vector2()
onready var acceleration = Vector2()
onready var pull_force = Vector2()
onready var turn_velocity = 0
onready var flying_speed = 8

onready var fuel = 100

func _ready():
	fuel_bar.value = fuel

func _process(delta):
	turn_velocity = 0
	acceleration = Vector2.ZERO
	if _can_move():
		turn_velocity = 0
		if Input.is_action_pressed("ui_left"):
			turn_velocity += -TURN_SPEED * delta
		if Input.is_action_pressed("ui_right"):
			turn_velocity += TURN_SPEED * delta
		
		acceleration = Vector2.ZERO
		if Input.is_action_pressed("ui_up"):
			acceleration += Vector2(flying_speed, 0).rotated(rotation)
		if Input.is_action_pressed("ui_down"):
			acceleration -= Vector2(flying_speed, 0).rotated(rotation)
	
	# Lose fuel when moving or turning
	if not (laser.is_colliding() and laser.get_collider() is Star):
		if acceleration != Vector2.ZERO or turn_velocity != 0:
			fuel -= FUEL_LOSS_RATE * delta
			fuel_bar.value = fuel
	
	if state == States.NORMAL:
		# Slowly pulled towards black holes
		var net_force = Vector2.ZERO
		for black_hole in get_tree().get_nodes_in_group("black_holes"):
			var angle = black_hole.global_position.angle_to_point(global_position)
			var dist = global_position.distance_to(black_hole.global_position)
			var magnitude = black_hole.get_pull_magnitude() + 8 * (1 - min(1, (dist / (black_hole.size * 600.0))))
			net_force += Vector2(magnitude, 0).rotated(angle)
		pull_force = net_force
	elif state == States.DEAD:
		pull_force = Vector2.ZERO

func _physics_process(delta):
	if state == States.NORMAL:
		var new_position = position + velocity * delta
		new_position.x = clamp(new_position.x, -6000, 6000)
		new_position.y = clamp(new_position.y, -6000, 6000)
		position = new_position
		velocity += acceleration + pull_force
		rotate(deg2rad(turn_velocity))
		
		velocity = velocity.clamped(MAX_SPEED)
		
		# Slow down to a stop
		velocity = lerp(velocity, Vector2.ZERO, 0.01)

func _can_move() -> bool:
	return state == States.NORMAL and fuel > 0

func _can_shoot() -> bool:
	return state == States.NORMAL

func refuel(delta) -> void:
	if fuel >= fuel_bar.max_value:
		fuel = fuel_bar.max_value
		return
	
	fuel += REFUEL_RATE * delta
	fuel_bar.value = fuel

func die() -> void:
	if state != States.DEAD:
		state = States.DEAD
		hide()
		emit_signal("died")

func consume() -> void:
	die()

func leave_level() -> void:
	state = States.FINISHED
	# TODO: warp out animation
	hide()
	emit_signal("escaped")

func _on_Player_body_entered(body):
	if body is Asteroid:
		die()
