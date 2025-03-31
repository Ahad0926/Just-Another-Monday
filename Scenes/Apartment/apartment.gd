extends BaseScene

@onready var dialogue_resource: DialogueResource

func _ready() -> void:
	super()
	if GameState.game_start == true:
		dialogue_resource = load("res://Dialogue/Dialogues/altoid.dialogue")
		DialogueManager.show_dialogue_balloon_scene("res://Dialogue/Balloon/balloon.tscn", dialogue_resource, "start", [GameState])
