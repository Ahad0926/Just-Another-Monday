extends Area2D

@export var desk_scene: String = "res://Scenes/desk_ui.tscn"  # Path to desk scene

func _on_body_entered(body):
	if body.name == "Player":
		print("Player near PC")
		body.near_pc = true  # Custom flag to enable interaction

func _on_body_exited(body):
	if body.name == "Player":
		print("Player left PC area")
		body.near_pc = false

func _process(delta):
	var player = get_tree().get_first_node_in_group("Player")
	if Input.is_action_just_pressed("player_interact") and $"../Player".near_pc:
		print("Entering Desk Scene")
		get_tree().change_scene_to_file(desk_scene)  # Switch to the desk UI scene
