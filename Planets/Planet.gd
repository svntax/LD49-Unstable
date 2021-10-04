extends KinematicBody2D
class_name Planet

export (int) var score_value = 10

const MAX_SPEED = 80
const SLOW_DOWN_RATE = 2

onready var health_ui = $UI
onready var health_bar = $UI/HealthBar

onready var velocity = Vector2()
onready var pull_force = Vector2()

func _ready():
	health_ui.hide()
	health_bar.value = health_bar.max_value

func _physics_process(delta):
	# Slowly pulled towards black holes
	var net_force = Vector2.ZERO
	for black_hole in get_tree().get_nodes_in_group("black_holes"):
		var angle = black_hole.global_position.angle_to_point(global_position)
		var dist = global_position.distance_to(black_hole.global_position)
		var magnitude = black_hole.get_pull_magnitude() + 8 * (1 - min(1, (dist / (black_hole.size * 600.0))))
		net_force += Vector2(magnitude, 0).rotated(angle)
	pull_force = net_force
	
	move_and_collide(velocity * delta)
	
	velocity += pull_force
	velocity = velocity.clamped(MAX_SPEED)
	
	# Slow down to a stop
	velocity = lerp(velocity, Vector2.ZERO, 0.01)

func lose_health(delta):
	health_ui.show()
	health_bar.value -= 20 * delta
	if health_bar.value <= 0:
		get_tree().root.get_node("Gameplay").add_score(score_value)
		queue_free()

func consume() -> void:
	queue_free()
