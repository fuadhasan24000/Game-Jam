extends CharacterBody2D
@onready var player: CharacterBody2D = $"."
@onready var marker_2d: Marker2D = $animation/Marker2D

@onready var animation: AnimatedSprite2D = $animation
const BULLET = preload("res://scene/bullet.tscn")
@onready var dashd: Timer = $dashd
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var health = 10000
const melee_damage = 20 
var isattaking = false;
var SPEED =110
const JUMP_VELOCITY = -300
var isshooting = false
var isdamaged = false
var isdead = false
var isdashing = false
var isfacing:int
var t: float
@onready var melee: Timer = $melee
@onready var gun: Timer = $gun
@onready var damage: Timer = $damage
@onready var death: Timer = $death
@onready var dash: Timer = $dash


	

func _physics_process(delta: float) -> void:
	# Add the gravity.

	if not is_on_floor():
		velocity += get_gravity()*delta

		

	# Handle jump.
	if Input.is_action_just_pressed("jump ") and is_on_floor() and GameManager.jumpG:
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
	if Input.is_action_just_pressed("attack melee") and GameManager.meleeG:
		animation.play("attack(melee)")
		melee.start()
		isattaking = true 
		$attack_area/CollisionShape2D.disabled = false
	if Input.is_action_just_pressed("fire") and GameManager.gunG:
		animation.play("attack(gun)")
		gun.start()
		isshooting= true

	if isattaking==false and isshooting==false and isdamaged==false and isdead==false and isdashing == false:
		if is_on_floor():
			if direction !=0 and Input.is_action_pressed("run") and GameManager.runG:
				animation.play("run")
			elif direction !=0 :
				animation.play("walk")
			else:
				animation.play("idle")
		else:
			animation.play("jump")
	
	if direction and Input.is_action_just_pressed("dash") and dash.is_stopped() and GameManager.dashG:
		dash.start()
		isdashing = true
		animation.play("run")
		await get_tree().create_timer(.15).timeout
		isdashing = false
	if isdashing:
		velocity.x = direction * SPEED*10
	elif direction and Input.is_action_pressed("run") and GameManager.runG:
		velocity.x = direction * SPEED*2 
	elif direction:
		velocity.x = direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if melee.is_stopped():
		isattaking = false
		$attack_area/CollisionShape2D.disabled = true
	if gun.is_stopped():
		isshooting = false
	if damage.is_stopped():
		isdamaged= false
	if death.is_stopped():
		pass





func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("harm"):
		health= health - 20
		print(health)
		isdamaged =true
		
		if health <= 0:
			isdead= true
			animation.play("death")
			death.start()
		if not isdead:
			animation.play("damage")
			damage.start()
	if area.is_in_group("box"):
		GameManager.scraps += 20
		area.queue_free()
		print(GameManager.scraps)
func _process(delta: float) -> void:
	animation.material.set_shader_parameter("is_damaged", isdamaged)
	if Input.is_action_just_pressed("fire") and GameManager.gunG:
		
		var bullet_instance = BULLET.instantiate()
		get_tree().root.add_child(bullet_instance)
		
		if isfacing == 1:
			bullet_instance.global_position = $animation/right.global_position
			bullet_instance.rotation = 0
		elif isfacing == -1:
			bullet_instance.global_position = $animation/left.global_position
			bullet_instance.rotation = PI
