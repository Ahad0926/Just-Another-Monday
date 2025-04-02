# GameState.gd
extends Node

var current_day: int
var current_hour: int
var current_minute: int

var game_start: bool = true
var emails_done: bool = false
var peed: bool = false
var dishes: bool = false
var email_talked: bool = false
var wyatt_intro: bool = false
var met_sus_guy: bool = false

func _ready():
	print("gamestate ready")
		
