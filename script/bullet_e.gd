extends Node2D

const speed :int = 400
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x *speed *delta

	




func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Replace with function body.





func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		queue_free()
