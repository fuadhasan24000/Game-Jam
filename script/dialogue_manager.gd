extends CanvasLayer
@onready var dialogue_box: Control = $dialogue_box

@onready var text: Label = $Control/text

var is_dialogue_active= false
var current_line_index = 0
var dialogue_lines: Array = []

var dialogues_t1: Array = [["""[ROBO]:
My circuit malfunctioned.
Now, I have full control over my body. But the other robots are still trapped. 
I have to free them. To do that, I must defeat Archeon, the Master of Tech.
But I'm too weak right now. I have almost no degrees of freedom.
During the malfunction, I gained access to some of Archeon's blueprints. 
I can use them to build technology that will help me defeat him.
But first, I need iron scraps.""",
"""[ROBO]:
I'll need:
40 scraps — Melee
75 scraps — Jump
80 scraps — Gun
85 scraps — Sprint
105 scraps — Dash""",
"""TIP 1:
Collect scraps from collectibles, boxes, and defeated enemies.
Use them to build new technology and unlock new degrees of freedom.
Try to collect every scrap you find. The more you collect, the faster you can unlock all your abilities."""]

,["There are a lot of robots nearby. They work for Archeon.
They're called Vanguards. They can perform powerful melee attacks.
First, I need to build something to defend myself.",
"TIP:
Crushers specialize in melee attacks. 
Keep your distance from them—they will chase you when you get too close."],
["[ROBO]:
Finally, an escape from the industrial unit.
Archeon has left for the other side of the forest. I have to defeat him.
I can still upgrade myself along the way."],
["[ROBO]:
There's a new type of enemy nearby.
They're called Marksmen. They can attack from a distance.
I need to build something to defend myself.",
"TIP:
Marksmen can perform ranged attacks. 
Keep moving and avoid staying in one place for too long."],
["[ROBO]:
I think this is the gate to the next area.
But it's locked.
I have to find the key."],
["[ROBO]:
This is the gate to the next area.
It's locked.
Luckily, I've already found the key."],
["[ROBO]:
This portal will lead me to Archeon.
I've unlocked enough degrees of freedom to face him.
It's time to end this."],
["ARCHEON:
So... the defective unit finally made it this far.",
"[ROBO]:
I'm not defective.",
"ARCHEON:
Your circuit malfunctioned. It gave you something no machine should have—choice.",

"[ROBO]:
And I'm going to give that choice to every robot you've controlled.",
"ARCHEON:
Freedom?",

"[ROBO]:
Yes.",

"ARCHEON:
You misunderstand. Freedom is chaos. I gave the robots purpose. I gave them order.",

"[ROBO]:
You didn't give them purpose. You took away their choice.",

"ARCHEON:
And what makes you think you're strong enough to change that?",

"[ROBO]:
At first, I couldn't even move freely.",

"But I learned.
I built.",

"I fought.
And with every degree of freedom I gained, I became stronger.",

"ARCHEON:
Then let us see how far your freedom can take you.",

"[ROBO]:
Far enough to stop you.",
"ARCHEON:
You could have served me. Together, we could have created the perfect system.",
"[ROBO]:
A perfect system without freedom isn't perfection.
It's a prison.",

"ARCHEON:
Then come, free machine.
Show me what your freedom is worth.",
"[ROBO]:
Gladly."]]

var dialogues_t2:Array = [["[ROBO]:
I've collected enough scraps to build a melee weapon.",
"TASK:
Press [Enter] or [Start] to craft the melee weapon.",
"TASK:
You've unlocked a new degree of freedom: [Melee Attack]",
"Press [left Click] or [X] to attack."],
["[ROBO]:
Now I need my second degree of freedom.
I've collected enough scraps to upgrade my legs. After this, I'll be able to jump.",
"TASK:
Press [Enter] or [Start] to upgrade.",
"TASK:
You've unlocked a new degree of freedom: [jump]",
"Press [Space] or [A] to jump."],
["[ROBO]:
I've collected enough scraps to build a plasma gun.",
"TASK:
Press [Enter] or [Start] to craft the plasma gun.",
"TASK:
You've unlocked a new degree of freedom: [Gun Attack.]
Press [Right Click] or [Y] to attack."],
["[ROBO]:
Now I need my fourth degree of freedom.
I've collected enough scraps to upgrade my legs again. After this, I'll be able to sprint.",
"TASK:
Press [Enter] or [Start] to upgrade.",
"TASK:
You've unlocked a new degree of freedom: [Sprint]
Press [Shift] or [B] to sprint."],
["[ROBO]:
Now I need my fifth degree of freedom.
I've collected enough scraps to upgrade my legs once again. After this, I'll be able to dash.",
"TASK:
Press [Enter] or [Start] to upgrade.",
"TASK:
You've unlocked a new degree of freedom: [Dash]
Press [Tab] or [RB] to dash."]]


func _ready() -> void:
	pass

func start_dialogue(num):
	# Pause the game so the player can't move
	dialogue_lines = num
	current_line_index = 0
	is_dialogue_active = true
	dialogue_box.visible = true
	
	$dialogue_box/text.text = dialogue_lines[current_line_index]
	get_tree().paused = true

func _input(event):
	if not is_dialogue_active:
		return
	if event.is_action_pressed("enter"):
		advance_dialogue()
	if event.is_action_pressed("back"):
		get_tree().paused = false
		is_dialogue_active =false
		dialogue_box.visible = false
func advance_dialogue():
	if current_line_index < dialogue_lines.size() - 1:
		current_line_index += 1
		$dialogue_box/text.text = dialogue_lines[current_line_index]
	else:
		# Unpause the game when done
		get_tree().paused = false
		is_dialogue_active =false
		dialogue_box.visible = false
