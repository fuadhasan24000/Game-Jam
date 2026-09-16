extends Area2D

var box = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if box and Input.is_action_just_pressed("enter"):
		GameManager.scraps+= 20
		print(GameManager.scraps)
		queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		box = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		box = false
