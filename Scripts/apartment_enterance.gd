extends Area2D

var entered = false

func _on_body_entered(body: CharacterBody2D) -> void:
	entered = true

func _on_body_exited(body: Node2D) -> void:
	entered = false

func _process(delta: float) -> void:
	if entered == true:
		if Input.is_action_pressed("player_input"):
			print("Player enters the apartment!")
			get_tree().change_scene_to_file("res://Scenes/apartment.tscn")
