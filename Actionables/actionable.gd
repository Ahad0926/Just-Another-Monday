# Actionable.gd
class_name Actionable extends Area2D

@export var action_id: String = ""
@export var dialogue_resource: DialogueResource
@export var remove_after_dialogue: bool = false

func action() -> void:
	print("\nInteracted with ", action_id, "\n")
	var npc = get_parent()
	
	# Make NPC face the player
	if npc.has_method("face_direction"):
		var player = get_tree().get_current_scene().get_node("player")
		npc.face_direction(player.global_position)

	# Connect to the dialogue_ended signal
	if not DialogueManager.is_connected("dialogue_ended", Callable(self, "_on_dialogue_ended")):
		DialogueManager.connect("dialogue_ended", Callable(self, "_on_dialogue_ended"))

	# Start the dialogue
	DialogueManager.show_dialogue_balloon_scene(
		"res://Dialogue/Balloon/balloon.tscn",
		dialogue_resource,
		"start",
		[GameState]
	)

func _on_dialogue_ended(ended_resource: DialogueResource) -> void:
	if ended_resource == dialogue_resource:
		await get_tree().create_timer(0.7).timeout

		var npc = get_parent()
		if npc.has_method("reset_facing"):
			npc.reset_facing()

		DialogueManager.disconnect("dialogue_ended", Callable(self, "_on_dialogue_ended"))

		if remove_after_dialogue:
			var player = npc.get_parent().get_node("player")
			player.freeze()
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			npc.queue_free()
			player.unfreeze()
