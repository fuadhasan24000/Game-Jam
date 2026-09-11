extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var health = 60
# Called when the node enters the scene tree for the first time.
var isdamaged = false
var isdead = false

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "damage":
		isdamaged= false
	if animated_sprite_2d.animation == "death":
		queue_free()
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("melee1"):
		print(health)
		health= health - 20
		isdamaged =true
		
		if health <= 0:
			isdead= true
			animated_sprite_2d.play("death")
		if not isdead:
			animated_sprite_2d.play("damage")
