extends Area2D

@export var target_scene: String = ""  # Scene file path to transition to
var entered = false

func _on_body_entered(body: CharacterBody2D) -> void:
	entered = true

func _on_body_exited(body: Node2D) -> void:
	entered = false

func _process(delta: float) -> void:
	if entered == true and target_scene != "":
		get_tree().change_scene_to_file(target_scene)
