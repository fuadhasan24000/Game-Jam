extends Node
var current_level: int = 1

# Player progression
var runG = true
var jumpG = true
var meleeG = true
var gunG= true
var dashG= true
# Collectables
var scraps:int = 0
	
# Story progression
var story_flags := {}

# Player information
var player_health: int = 100
func _process(delta: float) -> void:
	if scraps >= 40:
		meleeG= true
	if scraps >= 115:
		jumpG= true
	if scraps >= 195:
		gunG= true
	if scraps >= 280:
		runG= true
	if scraps >= 385:
		dashG= true	
