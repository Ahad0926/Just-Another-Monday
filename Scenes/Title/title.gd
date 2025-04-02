extends BaseScene
@onready var button = $StartButton
func _ready() -> void:
	super()
	canvas_modulate.freeze()
	time_canvas_layer.hide()

	# Optional: freeze the player so they're not active in memory
	if player:
		player.freeze()

	# Connect StartButton signal
	button.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	if canvas_modulate:
		canvas_modulate.unfreeze()
	if time_canvas_layer:
		time_canvas_layer.show()
	if player:
		player.unfreeze()

	await scene_manager.change_scene(self, "Apartment/apartment")
