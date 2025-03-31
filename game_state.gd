# GameState.gd
extends Node

var has_interacted_with_closet: bool = false
var game_start: bool = false
var emails_done: bool = false

func _ready():
	print("gamestate ready")
		
