extends Node2D

@onready var player: Player = $player
@onready var canvas_modulate = $CanvasModulate
@onready var time_canvas_layer = $Camera2D/CanvasLayer

func _ready() -> void:
	print("\nScene: Setup\n")
	call_deferred("_preload_pc_ui_and_start")

func _preload_pc_ui_and_start():
	# Load and instance the scene to fully parse its Control nodes, fonts, textures
	var temp_scene = preload("res://Scenes/PC/pc_ui.tscn").instantiate()
	
	# Add it off-screen so it doesn't show up
	temp_scene.visible = false
	temp_scene.position = Vector2(-99999, -99999)
	add_child(temp_scene)
	
	await get_tree().process_frame  # let Godot process all Control layout
	
	temp_scene.queue_free()  # clean it up once it's cached
	print("Preloaded and freed pc_ui.tscn")

	# Now switch scenes
	scene_manager.change_scene(self, "Title/title")
