extends CharacterBody2D
@onready var player: CharacterBody2D = $"."
@onready var marker_2d: Marker2D = $animation/Marker2D

@onready var animation: AnimatedSprite2D = $animation
const BULLET = preload("res://scene/bullet.tscn")

var health = 100
const melee_damage = 20 
var isattaking = false;
var SPEED =200
const JUMP_VELOCITY = -400.0
var isshooting = false
var isdamaged = false
var isdead = false
var isfacing:int



	

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
		isfacing =1
	elif direction < 0:
		animation.flip_h = true
		isfacing = -1
	if Input.is_action_just_pressed("attack melee"):
		animation.play("attack(melee)")
		isattaking = true 
		$Area2D/CollisionShape2D.disabled = false
	if Input.is_action_just_pressed("fire"):
		animation.play("attack(gun)")
		isshooting= true
	if isattaking==false and isshooting==false and isdamaged==false and isdead==false:
		if is_on_floor():
			if direction !=0 and Input.is_action_pressed("run"):
				animation.play("run")
			elif direction !=0 :
				animation.play("walk")
			else:
				animation.play("idle")
		else:
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
	if animation.animation == "attack(gun)":
		isshooting = false
	if animation.animation == "damage":
		isdamaged= false
	if animation.animation == "death":
		pass


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("harm"):
		health= health - 20
		print(health)
		isdamaged =true
		
		if health <= 0:
			isdead= true
			animation.play("death")
		if not isdead:
			animation.play("damage")
			print("blas")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.global_position = player.global_position
		if isfacing == 1:
			bullet_instance.rotation = 0
		elif isfacing == -1:
			bullet_instance.rotation = PI
