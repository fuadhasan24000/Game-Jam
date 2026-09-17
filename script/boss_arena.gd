extends Node2D
@onready var fade_overlay: ColorRect = $CanvasLayer/FadeOverlay


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$music.play()
	fade_overlay.show()
	fade_overlay.color = Color(0, 0, 0, 1.0)
	
	# Animate opacity from 1.0 (black) down to 0.0 (clear) over 1.5 seconds
	var tween = create_tween()
	tween.tween_property(fade_overlay, "color:a", 0.0, 1.8)
	
	# Turn it off after the animation finishes
	await tween.finished
	fade_overlay.hide()
	DialogueManager.start_dialogue(DialogueManager.dialogues_t1[7])
	GameManager.player_health = 200
	GameManager.Boss = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
