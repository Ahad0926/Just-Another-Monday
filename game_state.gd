# GameState.gd
extends Node

# Boolean to track if the player has met Nathan (or interacted with the closet)
var has_interacted_with_closet: bool = false
var game_start: bool = true

# This is where you can store more global state variables
# such as whether the player has met other characters or done other things

# Optional: Save state on disk so it persists between sessions (using _ready or a custom save method)
func _ready():
	print("gamestate ready")
		
