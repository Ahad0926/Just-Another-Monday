extends Area2D

var entered = false

func _on_body_entered(body: CharacterBody2D) -> void:
	entered = true

func _on_body_exited(body: Node2D) -> void:
	entered = false

func _process(delta: float) -> void:
	if entered == true:
		print("Player exits the apartment!")
		get_tree().change_scene_to_file("res://Scenes/hallway.tscn")  # Call scene loader in Main
