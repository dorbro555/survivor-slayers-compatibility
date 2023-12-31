extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 10.0
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
@export var hp = 80
@onready var _animation_player = $AnimationPlayer
var direction_dict = {}

var target_velocity = Vector3.ZERO


func _physics_process(delta):
	# Reset the direction and animation
	var direction = Vector3.ZERO
	_animation_player.pause()

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction.x == 1:
		_animation_player.play("Walk East") 
	elif direction.x == -1:
		_animation_player.play("Walk West")
	elif direction.z == -1:
		_animation_player.play("Walk North")
	elif direction.z == 1:
		_animation_player.play("Walk South")
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
#		$Pivot.look_at(position + direction, Vector3.UP)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()


func _on_hurtbox_hurt(damage):
	hp -= damage
	print(hp)
