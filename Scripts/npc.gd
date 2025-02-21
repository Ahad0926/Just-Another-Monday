extends CharacterBody2D

@export var npc_name: String
@export var animations: SpriteFrames  # Assign different animations per NPC
@export var default_dialogue: Array[String] = ["Hello.", "How are you?"]
@export var low_sanity_dialogue: Array[String] = ["You look... different.", "Are you okay?"]
@export var has_choices: bool = false
@export var dialogue_choices: Dictionary = {}

var player_nearby = false

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.frames = animations  # Set animations dynamically
	sprite.play("idle_up")  # Default to idle animation
	
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":
		player_nearby = true

func _on_body_exited(body):
	if body.name == "Player":
		player_nearby = false

func _process(delta):
	if player_nearby and Input.is_action_just_pressed("player_interact"):
		start_dialogue()

func start_dialogue():
	sprite.play("idle_down")  # Play talking animation
	var sanity = PlayerStats.sanity
	var dialogue = default_dialogue if sanity > 50 else low_sanity_dialogue
	var message = dialogue[randi() % dialogue.size()]  # Pick a random dialogue line
	
	if has_choices:
		DialogueManager.show_choices(npc_name, message, dialogue_choices)
	else:
		DialogueManager.show_message(npc_name, message)
	
	await get_tree().create_timer(1.5).timeout  # Wait before switching back
	sprite.play("idle_up")  # Return to idle animation
