extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if not GameState.emails_done:
			body.freeze()

			var dialogue_balloon = DialogueManager.show_dialogue_balloon_scene(
				"res://Dialogue/Balloon/balloon.tscn",
				load("res://Dialogue/Dialogues/altoid.dialogue"),
				"dont_leave",
				[GameState]
			)

			await dialogue_balloon.tree_exited

			# Push player upward
			await body.push(Vector2(0, -1), 24, 0.3)

			body.unfreeze()
