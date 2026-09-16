extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var health = 60

var isdamaged = false
var isdead = false
var isattacking = false 
@onready var right: RayCast2D = $right
@onready var left: RayCast2D = $left
@onready var below: RayCast2D = $below
@onready var collision_shape_2d: CollisionShape2D = $AttackArea/CollisionShape2D

var direction:int =1

enum State { PATROL, CHASE }

@export var speed := 20
@export var chase_speed := 45

var state: State = State.PATROL
var player: Node2D = null
var patrol_direction := 1.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var detection_area: Area2D = $DetectionArea
@onready var sprite: Sprite2D = $Sprite2D
func _process(delta: float) -> void:
	animated_sprite_2d.material.set_shader_parameter("is_damaged", isdamaged)
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	match state:
		State.PATROL:
			if not isdamaged:
				animated_sprite_2d.play("walk ")
			if right.is_colliding():
				direction = -1				
		
			elif left.is_colliding():
				direction = 1
				
			elif not below.is_colliding():
				direction = -direction
				animated_sprite_2d.flip_h = direction <0
			if direction == 1:
				animated_sprite_2d.flip_h = false
			elif direction == -1:
				animated_sprite_2d.flip_h = true

			velocity.x = direction * speed
			move_and_slide()
		State.CHASE:
			if player and not right.is_colliding() and not left.is_colliding() and below.is_colliding():
				var direction = sign(player.global_position.x - global_position.x)
				velocity.x = direction * chase_speed
				animated_sprite_2d.flip_h = direction <0
				move_and_slide()

	



func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		state = State.CHASE

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		state = State.PATROL


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("melee1"):
		health= health - 20
		isdamaged =true

		if health <= 0:
			isdead= true
			animated_sprite_2d.play("death")
			await get_tree().create_timer(.5).timeout
			GameManager.scraps+= 5
			queue_free()
		if not isdead:
			animated_sprite_2d.play("damage")
			await get_tree().create_timer(.5).timeout
			isdamaged= false





func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animated_sprite_2d.play("attack")
		isattacking = true
		collision_shape_2d.disabled = true
		await get_tree().create_timer(.5).timeout
		isattacking = false
		collision_shape_2d.disabled = false
