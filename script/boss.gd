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
var meleeattack = false
var isattacking = false
var direction:int =1
const chase_speed = 40
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
			if $walk2.is_stopped():
				$walk.play()
				$walk2.start()
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
				if direction>0:
					bullet_instance.global_position = $right.global_position
				if direction < 0:
					bullet_instance.global_position = $left.global_position
				bullet_instance.rotation = angle
				animated_sprite_2d.play("beam")
				$beam.play()
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
				
		State.PAUSE:
			pass
		
			
		State.SMASH:
			if smash_2.is_stopped():
				smash_2.start()
				animated_sprite_2d.play("pause")
				await get_tree().create_timer(1).timeout
				animated_sprite_2d.play("hulk smash")
				$smash3.play()

				$smash/smash.disabled = false
				await get_tree().create_timer(.4).timeout
				$smash/smash.disabled = true
				$smash3.stop()
				await get_tree().create_timer(1).timeout
				animated_sprite_2d.play("reverse smash")
				await get_tree().create_timer(1).timeout
				
				
	
var d_C1 = 10
var d_C2 = 5
var range1 =10
var bomb = 10
var smash = 10

func cycle():
	while GameManager.Boss_health >0:
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
	if area.is_in_group("melee1") or area.is_in_group("gun"):
		isdamaged =true
	if area.is_in_group("melee1"):
		GameManager.Boss_health -=30
		$hurt.play()
		$hurtB.play()
	else:
		GameManager.Boss_health -=15
		$hurtB.play()
		
	await get_tree().create_timer(.5).timeout
	isdamaged = false
	if GameManager.Boss_health <= 0:
		isdead= true
		get_tree().change_scene_to_file("res://scene/game_completed.tscn")
