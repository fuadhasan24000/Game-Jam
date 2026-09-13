extends CharacterBody2D
enum State {RANGE, RUN, MELEE, BOMB,SMASH, PAUSE}
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var beam_delay: Timer = $beam_delay
@onready var boss: CharacterBody2D = $"."
@onready var player: CharacterBody2D = $"../player"
@onready var collision_shape_2d: CollisionShape2D = $attack_area/CollisionShape2D
@onready var bomb_delay: Timer = $Bomb_delay
@onready var c_1: Timer = $C1
@onready var c_2: Timer = $c2
@onready var smash_2: Timer = $smash2
@onready var melee: Timer = $melee
var isdead = false
var isdamaged = false
var health = 1000
var meleeattack = false
var isattacking = false
var direction:int =1
const chase_speed = 100
var state:State
const BULLET = preload("res://scene/bulletB.tscn")
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
const PROJECTILE = preload("res://scene/projectile.tscn")
func _ready() -> void:
	cycle()
func _process(delta: float) -> void:
	animated_sprite_2d.material.set_shader_parameter("is_damaged", isdamaged)
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	match state:
		State.RUN:
			var direction = sign(player.global_position.x - global_position.x)
			velocity.x = direction * chase_speed
			animated_sprite_2d.flip_h = direction <0
			if melee.is_stopped() and meleeattack:
				melee.start()
				await get_tree().create_timer(1.5).timeout
				meleeattack =true
				$attack_area2/CollisionShape2D.disabled = false
				animated_sprite_2d.play("attack")
				await get_tree().create_timer(.5).timeout
				$attack_area2/CollisionShape2D.disabled = true
				meleeattack =false
			elif not meleeattack:
				animated_sprite_2d.play("move")
			move_and_slide()
		State.RANGE:
			if beam_delay.is_stopped():
				var direction = sign(player.global_position.x - global_position.x)
				var angle = (player.global_position - global_position).angle()
				animated_sprite_2d.flip_h = direction <0
				var bullet_instance = BULLET.instantiate()
				get_tree().root.add_child(bullet_instance)
				bullet_instance.global_position = boss.global_position
				bullet_instance.rotation = angle
				animated_sprite_2d.play("beam")
				beam_delay.start()
				
		State.BOMB:
			if bomb_delay.is_stopped():
				var direction = sign(player.global_position.x - global_position.x)
				var angle = (player.global_position - global_position).angle()
				animated_sprite_2d.flip_h = direction <0
				var speed = (player.global_position.distance_to(global_position)*gravity)**.5
				var bullet_instance = PROJECTILE.instantiate()
				get_tree().root.add_child(bullet_instance)
				bullet_instance.SPEED = speed
				bullet_instance.direction = direction
				bullet_instance.global_position = boss.global_position
				if direction == -1:
					bullet_instance.rotation = 0
				elif direction == 1:
					bullet_instance.rotation = PI
				animated_sprite_2d.play("bomb")
				bomb_delay.start()
				await get_tree().create_timer(1).timeout
				bomb_delay.start()
				
		State.PAUSE:
			pass
		
			
		State.SMASH:
			if smash_2.is_stopped():
				smash_2.start()
				animated_sprite_2d.play("hulk smash")
				$smash/smash.disabled = false
				await get_tree().create_timer(.3).timeout
				$smash/smash.disabled = true
				await get_tree().create_timer(1.7).timeout
		
				
	
var d_C1 = 20
var d_C2 = 10
var range1 =10
var bomb = 20
var smash = 6

func cycle():
	while health >0:
		c_1.start()
		state = State.RUN
		await get_tree().create_timer(d_C1).timeout
		meleeattack = false
		state = State.RANGE
		await get_tree().create_timer(range1).timeout
		state = State.RUN
		await get_tree().create_timer(d_C2).timeout
		meleeattack = false
		state = State.BOMB
		await get_tree().create_timer(bomb).timeout
		state = State.RUN
		await get_tree().create_timer(d_C2).timeout
		meleeattack = false
		state = State.SMASH
		await get_tree().create_timer(smash).timeout
	
	
	

func _on_attack_area_body_entered(body: Node2D) -> void:
	meleeattack = true

	
func _on_attack_area_body_exited(body: Node2D) -> void:
	meleeattack = false


func _on_hitbox_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("melee1"):
		health= health - 20
		isdamaged =true
		await get_tree().create_timer(.5).timeout
		isdamaged = false
		if health <= 0:
			isdead= true
			animated_sprite_2d.play("death")
