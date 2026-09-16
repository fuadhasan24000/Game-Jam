extends CanvasLayer
@onready var dialogue_box: Control = $dialogue_box

@onready var text: Label = $Control/text

var is_dialogue_active= false
var current_line_index = 0
var dialogue_lines: Array = []

var dialogues: Array = [["""My circuit malfunctioned.
Now, I have full control over my body. But the other robots are still trapped. 
I have to free them. To do that, I must defeat Archeon, the Master of Tech.
But I'm too weak right now. I have almost no degrees of freedom.
During the malfunction, I gained access to some of Archeon's blueprints. 
I can use them to build technology that will help me defeat him.
But first, I need iron scraps.""",
"""I'll need:
40 scraps — Melee
75 scraps — Jump
80 scraps — Gun
85 scraps — Sprint
105 scraps — Dash""",
"""TIP 1
Collect scraps from collectibles, boxes, and defeated enemies.
Use them to build new technology and unlock new degrees of freedom.
Try to collect every scrap you find. The more you collect, the faster you can unlock all your abilities."""]

,["There are a lot of robots nearby. They work for Archeon.
They're called Vanguards. They can perform powerful melee attacks.
First, I need to build something to defend myself.",
"TIP:
Crushers specialize in melee attacks. 
Keep your distance from them—they will chase you when you get too close."]]


const dialogue3: Array = []

func _ready() -> void:
	pass

func start_dialogue(num):
	# Pause the game so the player can't move
	get_tree().paused = true

	dialogue_lines = dialogues[num]
	current_line_index = 0
	is_dialogue_active = true
	dialogue_box.visible = true
	dialogue_lines[current_line_index]
	#$Control/text.text = "auowheiuhfpefp"

func _input(event):
	if not is_dialogue_active:
		return
	if event.is_action_pressed("enter"):
		advance_dialogue()

func advance_dialogue():
	if current_line_index < dialogue_lines.size() - 1:
		current_line_index += 1
		$text.text = dialogue_lines[current_line_index]
	else:
		# Unpause the game when done
		get_tree().paused = false
		is_dialogue_active =false
		dialogue_box.visible = false
