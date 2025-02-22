extends Control

@export var office_scene: String = "res://Scenes/office.tscn"

func _ready():
	print("Desk UI Opened")

func _on_button_pressed() -> void:
	print("Exiting Desk UI")
	get_tree().change_scene_to_file(office_scene)  # Return to the office scene
