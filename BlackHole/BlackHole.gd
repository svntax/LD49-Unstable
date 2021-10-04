extends Node2D

const GROW_RATE = 0.1

export (bool) var black_hole_disabled = false

onready var size = 1
onready var pull_magnitude = 2

func _ready():
	$GrowTimer.start()

func get_pull_magnitude() -> float:
	return size * pull_magnitude

func _physics_process(delta):
	if black_hole_disabled:
		return
	
	scale.x += GROW_RATE * delta
	scale.y += GROW_RATE * delta

func _on_GrowTimer_timeout():
	size += 0.02

func _on_Area2D_area_entered(area):
	if area.has_method("consume"):
		area.consume()

func _on_Area2D_body_entered(body):
	if body.has_method("consume"):
		body.consume()
