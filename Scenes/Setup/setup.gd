extends Node2D

@onready var player: Player = $player
@onready var canvas_modulate = $CanvasModulate
@onready var time_canvas_layer = $Camera2D/CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Game initialized!\n")
	scene_manager.change_scene(self, "Title/title")
