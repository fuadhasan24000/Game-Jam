extends CharacterBody2D
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
@export var SPEED = 100
@export var direction:int
@onready var collision_shape_2d_2: CollisionShape2D = $"daamge area/CollisionShape2D2"
@onready var explosion: AnimatedSprite2D = $explosion
@onready var sprite_2d: Sprite2D = $Sprite2D


var time: float
func _ready():
	explosion.hide()
	
func _physics_process(delta):
	time += delta
	if not is_on_floor():
		velocity.x = direction * SPEED *(.707106)
		velocity.y = -SPEED*(.707106)+ gravity * time
	
	else:
		await get_tree().create_timer(.3).timeout
		collision_shape_2d_2.disabled = false
		sprite_2d.hide()
		explosion.show()
		explosion.play("explotion")
		await get_tree().create_timer(.5).timeout
		
		queue_free()
	move_and_slide()
