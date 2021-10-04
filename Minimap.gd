extends Node2D

const RING_COLOR = Color("9badb7")
const WARP_COLOR = Color("99e550")
const STAR_COLOR = Color("df7126")

export (NodePath) var player_path = ""
var player

export (NodePath) var exit_warp_path = ""
var exit_warp

export (NodePath) var star_path = ""
var star

func _ready():
	player = get_node_or_null(player_path)
	star = get_node_or_null(star_path)
	exit_warp = get_node_or_null(exit_warp_path)

func _process(delta):
	update()
	if Input.is_action_just_pressed("toggle_minimap"):
		visible = not visible

func _draw():
	# Borders
	draw_rect(Rect2(-60, -60, 120, 120), Color.white, false)
	
	# Outer ring
	draw_circle_arc(Vector2.ZERO, 45, 0, 360, RING_COLOR)
	# Middle ring
	draw_circle_arc(Vector2.ZERO, 30, 0, 360, RING_COLOR)
	
	if star != null and is_instance_valid(star):
		draw_circle(Vector2.ZERO, 4, STAR_COLOR)
	else:
		# Assume there's a black hole instead
		draw_circle(Vector2.ZERO, 4, Color.black)
	if player != null:
		draw_circle(player.global_position / 100, 2, Color.white)
	if exit_warp != null:
		draw_circle(exit_warp.global_position / 100, 2, WARP_COLOR)

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)
