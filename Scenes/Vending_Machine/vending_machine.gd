extends BaseScene

@onready var items := []
@export var dialogue_resource: DialogueResource

func _ready() -> void:
	super()
	# Gather all TextureButton children and connect signals
	for child in get_children():
		if child is TextureButton:
			items.append(child)
			child.pressed.connect(_on_item_pressed.bind(child))
			

func _on_item_pressed(button: TextureButton) -> void:
	# Connect to the dialogue_ended signal
	if not DialogueManager.is_connected("dialogue_ended", Callable(self, "_on_dialogue_ended")):
		DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"))
		
	var item_name = button.name
	await DialogueManager.show_dialogue_balloon_scene(
		"res://Dialogue/Balloon/balloon.tscn",
		dialogue_resource,
		item_name,
		[GameState]
	)
	
func _on_dialogue_ended(ended_resource: DialogueResource) -> void:
	# Only reset if this actionable started the dialogue
	if ended_resource == dialogue_resource:
		await get_tree().create_timer(0.7).timeout  # short delay before reset

		# Disconnect to avoid memory leaks or duplicate calls
		DialogueManager.disconnect("dialogue_ended", Callable(self, "_on_dialogue_ended"))
		scene_manager.change_scene(self, "Lobby/lobby")
