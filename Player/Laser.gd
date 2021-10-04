extends RayCast2D

# Based on https://www.youtube.com/watch?v=dg0CQ6NPDn8

onready var line = $Line2D
onready var tween = $Tween
onready var hit_particles = $HitParticles
onready var start_sprite = $Start
onready var end_sprite = $End

onready var is_casting = false
onready var last_object_detected = null

func _ready():
	set_physics_process(false)
	line.width = 0
	hit_particles.emitting = false
	cast_to = Vector2.ZERO
	start_sprite.scale = Vector2.ZERO
	end_sprite.scale = Vector2.ZERO

func _process(delta):
	if not get_parent()._can_shoot():
		set_is_casting(false)
	else:
		set_is_casting(Input.is_action_pressed("shoot"))

func _physics_process(delta):
	var cast_point = cast_to
	force_raycast_update()
	
	hit_particles.emitting = is_casting
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		hit_particles.global_rotation = get_collision_normal().angle()
		hit_particles.process_material.initial_velocity = 220
		hit_particles.process_material.spread = 45
		
		var collider = get_collider()
		if collider.has_method("lose_health"):
			collider.lose_health(delta)
		elif collider is Star:
			get_parent().refuel(delta)
			collider.drain_energy(delta)
	else:
		cast_point = to_local(get_global_mouse_position())
		hit_particles.process_material.initial_velocity = 120
		hit_particles.process_material.spread = 180
	
	hit_particles.position = cast_point
	end_sprite.position = cast_point
	line.points[1] = cast_point
	cast_to = to_local(get_global_mouse_position())

func set_is_casting(cast: bool) -> void:
	set_physics_process(cast)
	if !is_casting and cast:
		appear()
	elif is_casting and not cast:
		hit_particles.emitting = false
		disappear()
		cast_to = Vector2.ZERO
	is_casting = cast

func appear() -> void:
	tween.stop_all()
	tween.interpolate_property(line, "width", 0, 6.0, 0.2)
	tween.interpolate_property(start_sprite, "scale", Vector2.ZERO, Vector2(0.8, 0.8), 0.2)
	tween.interpolate_property(end_sprite, "scale", Vector2.ZERO, Vector2(0.8, 0.8), 0.2)
	tween.start()

func disappear() -> void:
	tween.stop_all()
	tween.interpolate_property(line, "width", 6.0, 0, 0.1)
	tween.interpolate_property(start_sprite, "scale", Vector2(0.8, 0.8), Vector2.ZERO, 0.1)
	tween.interpolate_property(end_sprite, "scale", Vector2(0.8, 0.8), Vector2.ZERO, 0.1)
	tween.start()
