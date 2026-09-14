extends Node
var current_level: int = 1

# Player progression
var unlocked_abilities := {
	"dash": false,
	"double_jump": false,
	"wall_jump": false,
	"special_attack": false
}

# Collectables
var collected_items := {}

# Story progression
var story_flags := {}

# Player information
var player_health: int = 100
