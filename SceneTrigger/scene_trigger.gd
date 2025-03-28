class_name SceneTrigger extends Area2D

@export var connected_scene: String
@export var is_interact: bool

var scene_folder = "res://Scenes/"

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if is_interact:
			print("Press interact key to switch scenes")  # Debug message
		else:
			scene_manager.change_scene(get_owner(), connected_scene)

func _unhandled_input(event: InputEvent) -> void:
	if is_interact and event.is_action_pressed("player_interact"):
		var player = get_overlapping_bodies().filter(func(b): return b is Player)
		if player.size() > 0:
			print("Interacted with scene trigger, switching scene")  # Debug message
			scene_manager.change_scene(get_owner(), connected_scene)
