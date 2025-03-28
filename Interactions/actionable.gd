# Actionable.gd
class_name Actionable extends Area2D

@export var action_id: String = ""
@export var dialogue_resource: DialogueResource

func action() -> void:
	print("\nInteracted with ", action_id, "\n")
	DialogueManager.show_dialogue_balloon_scene("res://Dialogue/Balloon/balloon.tscn", dialogue_resource, "start", [GameState])
	
