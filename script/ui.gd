extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$score.text= "Scraps: " + str(GameManager.canvas_scraps)
	$heath.text= "Health: " + str(GameManager.player_health)
	$"boss health".text = str(GameManager.Boss_health)
	if GameManager.die_delay:
		$died.visible = true
		$ColorRect.visible = true
	else:
		$died.visible = false
		$ColorRect.visible = false
	if GameManager.Boss:
		$"boss health".visible = true
