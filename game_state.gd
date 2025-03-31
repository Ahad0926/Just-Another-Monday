# GameState.gd
extends Node

var game_start: bool = true
var emails_done: bool = false
var peed: bool = false
var dishes: bool = false


func _ready():
	print("gamestate ready")
		
