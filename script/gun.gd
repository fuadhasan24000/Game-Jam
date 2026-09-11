extends Node2D
#
#var rotationj:float
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass
#
#const BULLET = preload("res://scene/bullet.tscn")
#const player = preload("res://scene/player.tscn")
#@onready var muzzle: Marker2D = $Muzzle
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#var direction := Input.get_axis("left", "right")
	## Read the joystick axis vector (Right Stick)
	#var joystick_vector := Input.get_vector("left", "right", "up", "down")
	#
	#if joystick_vector.length() > 0.2: # Deadzone threshold
		## Point in the direction of the joystick stick
		#rotation = joystick_vector.angle()
	#else:
		## Fall back to mouse aiming if joystick is idle
		#look_at(get_global_mouse_position())
#
	## Keep your existing scale flip logic
	#rotation_degrees = wrap(rotation_degrees, 0, 360)
	#if rotation_degrees > 90 and rotation_degrees < 270:
		#scale.y = -.5
		#rotation_degrees = 180
	#else:
		#scale.y = .5
		#rotation_degrees = 0
	#
	#if Input.is_action_just_pressed("fire"):
		#
		#var bullet_instance = BULLET.instantiate()
		#get_tree().root.add_child(bullet_instance)
		#bullet_instance.global_position = muzzle.global_position
		#bullet_instance.rotation = rotation
