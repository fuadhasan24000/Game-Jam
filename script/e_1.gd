extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const BULLET = preload("res://scene/bulletE.tscn")
var health = 60
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var isdamaged = false
var isdead = false
var speed = 100
var isattacking = false 
@onready var right: RayCast2D = $right
@onready var left: RayCast2D = $left
@onready var below: RayCast2D = $below
@onready var enemy: CharacterBody2D = $"."
@onready var ray: RayCast2D = $ray
@onready var timer: Timer = $Timer





var direction:int =1

enum State { PATROL, SHOOT }

var state: State = State.PATROL
var player: Node2D = null
var patrol_direction := 1.0


@onready var detection_area: Area2D = $DetectionArea
@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	animated_sprite_2d.material.set_shader_parameter("is_damaged", isdamaged)
	if not is_on_floor():
		velocity.y += gravity * delta

	match state:
		State.PATROL:
			if not isdamaged:
				animated_sprite_2d.play("move")
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
		State.SHOOT:
			if player and timer.is_stopped():
				var direction = sign(player.global_position.x - global_position.x)
				var angle = (player.global_position - global_position).angle()
				animated_sprite_2d.flip_h = direction <0
				var bullet_instance = BULLET.instantiate()
				get_tree().root.add_child(bullet_instance)
				bullet_instance.global_position = enemy.global_position
				bullet_instance.rotation = angle
				timer.start()
				animated_sprite_2d.play("fire")
				

	move_and_slide()




func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("melee1"):
		health= health - 20
		print(health)
		isdamaged =true
		
		if health <= 0:
			isdead= true
			animated_sprite_2d.play("death")
		if not isdead:
			animated_sprite_2d.play("damage")
			print("blas")
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("melee1"):
		print(health)
		health= health - 20
		isdamaged =true

		
		if health <= 0:
			isdead= true
			animated_sprite_2d.play("death")
			await get_tree().create_timer(.5).timeout
			queue_free()
		if not isdead:
			animated_sprite_2d.play("damage")
			await get_tree().create_timer(.5).timeout
			isdamaged= false

		


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		state = State.SHOOT

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		state = State.PATROL
