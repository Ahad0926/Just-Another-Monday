# GameState.gd
extends Node

var current_day: int
var current_hour: int
var current_minute: int

var game_start: bool = false
var emails_done: bool = true
var peed: bool = false
var dishes: bool = false
var email_talked: bool = false
var wyatt_intro: bool = false

func _ready():
	print("gamestate ready")
		
