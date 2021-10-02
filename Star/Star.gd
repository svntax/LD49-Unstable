extends Node2D

const GROW_RATE = 0.01

onready var black_hole_scene = load("res://BlackHole/BlackHole.tscn")

onready var grow_timer = $GrowTimer
onready var shake_timer = $ShakeTimer
onready var animation_player = $AnimationPlayer

onready var rumbling = false
onready var original_pos = $Sun.position

func _ready():
	#scale = Vector2(0.5, 0.5)
	scale = Vector2(1.05, 1.05) # TODO balance numbers
	grow_timer.start()

func _physics_process(delta):
	scale.x += GROW_RATE * delta
	scale.y += GROW_RATE * delta
	
	if scale.x >= 1.1 and scale.y >= 1.1:
		var black_hole = black_hole_scene.instance()
		get_parent().add_child(black_hole)
		black_hole.position = position
		queue_free()

func _on_GrowTimer_timeout():
	if scale.x >= 1 and scale.y >= 1:
		grow_timer.stop()
		rumbling = true
		animation_player.play("flashing")
		shake_timer.start()

func _on_ShakeTimer_timeout():
	if rumbling:
		$Sun.position = original_pos + Vector2(rand_range(-4, 4), rand_range(-4, 4))

func _on_Area2D_area_entered(area):
	if area.has_method("consume"):
		area.consume()
