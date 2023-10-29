extends Node3D


@export var enemy_spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group('player')
# Let's grab the camera to calculate what's inside the viewport

var camera : Camera3D
var frustum_planes : Array[Plane]
var spawn_position : Vector3

var wave_timer : float = 0.0
var total_time_elapsed : float = 0.0
var last_spawn_time : float = 0.0
var current_wave_idx : int = 0
var current_wave : Spawn_info
var current_enemy : Resource
var current_enemy_count : int
var enemy_spawn : Node = null

var time = 0

func _ready():
	setupReferences()
	for i in range(current_wave.enemy_min):
		enemy_spawn = current_enemy.instantiate()
		enemy_spawn.transform.origin = get_random_position()
		add_child(enemy_spawn)
	current_enemy_count = current_wave.enemy_min
# clear our the variable
	enemy_spawn = null
	
func _process(delta):
	wave_timer += delta
#	 May not need the below
	total_time_elapsed += delta
	print(total_time_elapsed)
#	Check if we need to update the wave to the next enemy
	if wave_timer >= current_wave.time_length:
		current_wave_idx += 1
		wave_timer = 0.0
#		redefine the current enemy spawn
		current_wave = enemy_spawns[current_wave_idx]
		current_enemy = current_wave.enemy
		current_enemy_count = 0
#	Lets check if it's been atleast 1 second since the last spawn
	if total_time_elapsed - last_spawn_time  >= 1:
#		First lets check if we need to spawn up to the minimum
		if current_enemy_count < current_wave.enemy_min:
			for i in range(current_wave.enemy_min):
				enemy_spawn = current_enemy.instantiate()
				enemy_spawn.transform.origin = get_random_position()
				add_child(enemy_spawn)
				current_enemy_count += 1
#		Define the amount of spawns needed
		var spawn_amount = (wave_timer - last_spawn_time) / current_wave.enemy_spawn_delay
		for i in range(spawn_amount):
#			Lets create and store an instance of our SpawnInfo class
			enemy_spawn = current_enemy.instantiate()
			enemy_spawn.transform.origin = get_random_position()
			add_child(enemy_spawn)
			current_enemy_count += 1
#			clear out the variable for the next iteration
			enemy_spawn = null
		last_spawn_time = total_time_elapsed

func setupReferences():
	# Initialize variables
#	Lets start with the camera variables
	camera = get_tree().get_first_node_in_group('camera')
	frustum_planes = camera.get_frustum()
	# Then our initial wave spawn, spawning up to the minimum
	current_wave = enemy_spawns[current_wave_idx]
	current_enemy = current_wave.enemy

func get_random_position():
	
	# We define the viewports size by referencing the frustum of our camera.
	# We get the width by getting the distance to the left frustum plane, which is perpendicular
	# Then we grab the distance to the top, and using trig find the distance on the xz-plane
	# then we multiply both results by a random factor to add a gap between the screen and spawn points
	var vpr = Vector2(frustum_planes[2].d * randf_range(1.1, 1.2), frustum_planes[3].d * 1.414 * randf_range(1.1, 1.2))
#	print('viewport is: ', vpr)
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
