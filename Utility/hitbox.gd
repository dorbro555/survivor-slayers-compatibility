extends Area3D

@export var damage = 1

@onready var collision = $CollisionShape3D
@onready var disableTimer = $DisableHitBoxTimer

func tempdisable():
	collision.call_deferred('set','disabled',true)
	disableTimer.start()


func _on_disable_hitbox_timer_timeout():
	collision.call_deferred('set','disabled',false)
