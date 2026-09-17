extends Control

@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton
@onready var card_panel: PanelContainer = %CardPanel
@onready var title_label: Label = %TitleLabel

func _ready() -> void:
	# Connect buttons
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# Initial entrance animation
	if card_panel:
		card_panel.modulate.a = 0.0
		card_panel.scale = Vector2(0.9, 0.9)
		card_panel.pivot_offset = card_panel.size / 2.0
		
		var tween: Tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(card_panel, "modulate:a", 1.0, 0.6)
		tween.tween_property(card_panel, "scale", Vector2.ONE, 0.6)

func _on_restart_pressed() -> void:
	# If a main gameplay scene exists, navigate there; otherwise reload current scene
	if ResourceLoader.exists("res://levels/menu.tscn"):
		get_tree().change_scene_to_file("res://levels/menu.tscn")
	else:
		get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
