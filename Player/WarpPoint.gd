extends Area2D

onready var status_label = $UI/StatusLabel

onready var exit_ready = false

func _ready():
	status_label.set_text("Ready")
	$ReadyTimer.start()

func _on_WarpPoint_area_entered(area):
	if exit_ready and area.has_method("leave_level"):
		area.leave_level()
		status_label.hide()

func _on_ReadyTimer_timeout():
	exit_ready = true
	status_label.set_text("Exit")
