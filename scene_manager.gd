class_name SceneManager extends Node

var player: Player
var last_scene_name: String
var canvas_modulate: DayNightCycle
var time_canvas_layer: CanvasLayer

var scene_dir_path = "res://Scenes/"

func change_scene(from, to_scene_name: String, skip_transition: bool = false) -> void:
	last_scene_name = from.name
	player = from.player
	player.get_parent().remove_child(player)
	
	canvas_modulate = from.canvas_modulate
	canvas_modulate.get_parent().remove_child(canvas_modulate)
	
	time_canvas_layer = from.time_canvas_layer
	time_canvas_layer.get_parent().remove_child(time_canvas_layer)
	
	var full_path = scene_dir_path + to_scene_name + ".tscn"
	print("changing scene from ", last_scene_name, " to ", to_scene_name)
	
	if not skip_transition:
		player.freeze()
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		player.unfreeze()
	
	from.get_tree().call_deferred("change_scene_to_file", full_path)
	
