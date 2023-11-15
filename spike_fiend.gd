extends CharacterBody3D

# Minimum speed of the mob in meters per second.
@export var movement_speed = 3.0
# Get player node
@onready var player = get_tree().get_first_node_in_group('player')
# Get animation player
@onready var _animation_player = $AnimationPlayer
@export var hp = 10

func _physics_process(_delta):
	# We set the mob to always be looking in the direction of the player
	look_at_from_position(global_position, player.global_position, Vector3.UP)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * movement_speed
	# We then rotate the velocity vector based on the mob's Y rotation
	# in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	move_and_slide()
	
	# Angles is defined as starting at 6o'clock at -180, going counter-clockwise
	if rotation_degrees.y >= -22.5 && rotation_degrees.y < 22.5 :
		_animation_player.play("Walk North")
	elif rotation_degrees.y >= 22.5 && rotation_degrees.y < 67.5 :
		_animation_player.play("Walk NW")
	elif rotation_degrees.y >= 67.5 && rotation_degrees.y < 112.5 :
		_animation_player.play("Walk West")
	elif rotation_degrees.y >= 112.5 && rotation_degrees.y < 157.5 :
		_animation_player.play("Walk SW")
	elif rotation_degrees.y >= 157.5 && rotation_degrees.y < -157.5 :
		_animation_player.play("Walk South")
	elif rotation_degrees.y >= -157.5 && rotation_degrees.y < -112.5 :
		_animation_player.play("Walk SE")
	elif rotation_degrees.y >= -112.5 && rotation_degrees.y < -67.5 :
		_animation_player.play("Walk East")
	elif rotation_degrees.y >= -67.5 && rotation_degrees.y < -22.5 :
		_animation_player.play("Walk NE")
	else:
		_animation_player.play("RESET")

# This function will be called from the Main scene.
#func initialize(start_position, player_position):
#	# We position the mob by placing it at start_position
#	# and rotate it towards player_position, so it looks at the player.
#	look_at_from_position(start_position, player_position, Vector3.UP)
#	# Rotate this mob randomly within range of -90 and +90 degrees,
#	# so that it doesn't move directly towards the player.
#	rotate_y(randf_range(-PI / 4, PI / 4))
#
#	# We calculate a random speed (integer)
#	var random_speed = randi_range(min_speed, max_speed)
#	# We calculate a forward velocity that represents the speed.
#	velocity = Vector3.FORWARD * random_speed
#	# We then rotate the velocity vector based on the mob's Y rotation
#	# in order to move in the direction the mob is looking.
#	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
