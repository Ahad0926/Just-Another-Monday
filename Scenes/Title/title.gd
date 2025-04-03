extends BaseScene

@onready var time_ui = $"../Camera2D/CanvasLayer/DayNightCycleUI"
@onready var button = $StartButton

func _ready() -> void:
	print("\ntitle screen before super")
	super()
	print("\ntitle screen affter super")

	if canvas_modulate:
		print("Title Freezing!")
		canvas_modulate.freeze()
		if time_canvas_layer:
			time_canvas_layer.visible = false
		player.freeze()

	# Connect StartButton signal
	button.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	print("\nGame started!\n")
	if canvas_modulate:
		canvas_modulate.unfreeze()
	if time_canvas_layer:
		time_canvas_layer.show()
	if player:
		player.unfreeze()

	await scene_manager.change_scene(self, "Apartment/apartment")
