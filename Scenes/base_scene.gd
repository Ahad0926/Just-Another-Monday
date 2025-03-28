class_name BaseScene extends Node

@onready var player: Player = $player
@onready var entrance_markers: Node2D = $EntranceMarkers
@onready var camera = $Camera2D
@onready var phantom_camera = $PhantomCamera2D
@onready var things: TileMapLayer = $Things  # Reference to the "Things" TileMapLayer

@onready var canvas_modulate = $CanvasModulate
@onready var time_canvas_layer = $Camera2D/CanvasLayer

func _ready() -> void:
	print("Scene: ", name)
		
	position_player()
	position_camera()
	sync_time()
	print(player)
	print(canvas_modulate)
	print(time_canvas_layer)
	print("")

func position_player() -> void:
	# Setup player
	if scene_manager.player:
		if player:
			player.queue_free()
			print(player, " freed")
		
		player = scene_manager.player
		add_child(player)
		player.name = "player"
		print(player, " added")
		
		
	var last_scene = scene_manager.last_scene_name.to_lower().replace('_', '').replace(' ', '')
	if last_scene.is_empty():
		last_scene = "any"
	
	for entrance in entrance_markers.get_children():
		var entrance_name = entrance.name.to_lower().replace('_', '').replace(' ', '')
		if entrance is Marker2D and (entrance_name == last_scene or entrance_name == "any"):
			print(entrance)
			player.global_position = entrance.global_position
			
func position_camera() -> void:
	var eyes = player.get_node("Eyes")
	
	# Setup camera
	if phantom_camera:
		phantom_camera.follow_target = eyes

func sync_time() -> void:
	if scene_manager.canvas_modulate:
		if canvas_modulate:
			print("Already have canvas!")
			print(canvas_modulate)
			canvas_modulate.queue_free()
			print("removed canvas ", canvas_modulate)
			
		
		canvas_modulate = scene_manager.canvas_modulate
		print("Adding canvas")
		add_child(canvas_modulate)
	
	if scene_manager.time_canvas_layer:
		if time_canvas_layer:
			time_canvas_layer.queue_free()
		
		time_canvas_layer = scene_manager.time_canvas_layer
		camera.add_child(time_canvas_layer)
		
	if canvas_modulate:
		if time_canvas_layer:
			time_canvas_layer.visible = true
		canvas_modulate.time_tick.connect(time_canvas_layer.get_child(0).set_daytime)
