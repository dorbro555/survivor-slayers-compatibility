extends Node3D


@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group('player')
# Let's grab the camera to calculate what's inside the viewport

var camera : Camera3D
var frustum_planes : Array[Plane]
var spawn_position : Vector3

var time = 0

func _ready():
	setupReferences()
	

func _on_timer_timeout():
	time += 1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
#					enemy_spawn.global_position = get_random_position()
#					enemy_spawn.transform.origin = spawn_position
					enemy_spawn.transform.origin = get_random_position()
#					print('enemy spawned at: ', enemy_spawn.transform.origin)
					add_child(enemy_spawn)
					counter += 1


func setupReferences():
	# Initialize variables
	camera = get_tree().get_first_node_in_group('camera')
	# Grab values to calc the 'Frustum' (fancy term for whats in view)
	var camera_size = camera.get_size()
	frustum_planes = camera.get_frustum()
	print(camera_size)
	print(camera.get_keep_aspect_mode())
#	var near_plane_distance = camera.get_near()
#	# Now get the top spawn position
#	var spawn_distance = 2.0  # Adjust this value based on how far outside the view you want to spawn the enemy
#
#	var camera_global_transform = camera.global_transform
#	var camera_location = camera_global_transform.origin
#	var camera_basis = camera_global_transform.basis
#	# And now the magic formula
#	spawn_position = camera_location - (camera_basis.x * (camera_size / 2.0)) - (camera_basis.y * (camera_size / 2.0)) - (camera_basis.z * spawn_distance)



func get_random_position():
	
#	var vpr = get_viewport().get_visible_rect().size * randf_range(1.1,1.4)
	# We define the viewports size by referencing the frustum of our camera.
	# We get the width by getting the distance to the left frustum plane, which is perpendicular
	# Then we grab the distance to the top, and using trig find the distance on the xz-plane
	# then we multiply both results by a random factor to add a gap between the screen and spawn points
	var vpr = Vector2(frustum_planes[2].d * randf_range(1.1, 1.2), frustum_planes[3].d * 1.414 * randf_range(1.1, 1.2))
	print('viewport is: ', vpr)
	var top_left = Vector3(player.global_position.x - vpr.x, 0, player.global_position.z - vpr.y)
	var top_right = Vector3(player.global_position.x + vpr.x, 0, player.global_position.z - vpr.y)
	var bottom_left = Vector3(player.global_position.x - vpr.x, 0, player.global_position.z + vpr.y)
	var bottom_right = Vector3(player.global_position.x + vpr.x, 0, player.global_position.z + vpr.y)
	var pos_side = ["up","down","right","left"].pick_random()
#	var pos_side = "left"
	var spawn_pos1 = Vector3.ZERO
	var spawn_pos2 = Vector3.ZERO

	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left

	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var z_spawn = randf_range(spawn_pos1.z,spawn_pos2.z)
	print(spawn_pos1, spawn_pos2, Vector3(x_spawn,0, z_spawn))
	return Vector3(x_spawn,0, z_spawn)
