extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $animation


var health = 100
const melee_damage = 20 
var isattaking = false;
var SPEED =200
const JUMP_VELOCITY = -400.0




	

func _physics_process(delta: float) -> void:
	# Add the gravity.

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump ") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction> 0:
		animation.flip_h = false
	elif direction < 0:
		animation.flip_h = true
	if Input.is_action_just_pressed("attack melee"):
		animation.play("attack(melee)")
		isattaking = true 
		$Area2D/CollisionShape2D.disabled = false
	if is_on_floor() and isattaking ==false :
		
		if direction !=0 and Input.is_action_pressed("run"):
			animation.play("run")
		elif direction !=0 :
			animation.play("walk")
		else:
			animation.play("idle")
	elif isattaking ==false:
		animation.play("jump")
	

	if direction and Input.is_action_pressed("run"):
		velocity.x = direction * SPEED*2 
	elif direction:
		velocity.x = direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()






func _on_animation_animation_finished() -> void:
	if animation.animation == "attack(melee)":
		isattaking = false
		$Area2D/CollisionShape2D.disabled = true 
