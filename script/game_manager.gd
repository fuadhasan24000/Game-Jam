extends Node
var current_level: int = 1
var story:bool = false
var runG = true
var jumpG = true
var meleeG =true
var gunG= true
var dashG= true
var scrap1=0
var scrap2=0
var scrap3=0
var ascrap1=0
var ascrap2=0
var ascrap3=0
var scraps:int = 0
var canvas_scraps:=0 
var Boss_health: int =1000
# Story progression
var story_flags := {}
var die_delay
var Boss = false
# Player information
var player_health: int = 200
func _process(delta: float) -> void:

	if scraps >= 40:
		if not meleeG:
			DialogueManager.start_dialogue(DialogueManager.dialogues_t2[0])
			meleeG= true
			canvas_scraps = 0
	if scraps >= 115:
		if not jumpG:
			DialogueManager.start_dialogue(DialogueManager.dialogues_t2[1])
			jumpG= true
			canvas_scraps = 0
	if scraps >= 195:
		if not gunG:
			DialogueManager.start_dialogue(DialogueManager.dialogues_t2[2])
			gunG= true
			canvas_scraps = 0
		
	if scraps >= 280:
		if not runG:
			DialogueManager.start_dialogue(DialogueManager.dialogues_t2[3])
			runG= true
			canvas_scraps = 0
	if scraps >= 385:
		if not dashG:
			DialogueManager.start_dialogue(DialogueManager.dialogues_t2[4])
			dashG= true
			canvas_scraps = 0
