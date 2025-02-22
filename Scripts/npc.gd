extends CharacterBody2D

@export var npc_name: String
@export var animations: SpriteFrames  # Assign different animations per NPC
@export var default_dialogue: Array[String] = ["Hello.", "How are you?"]
@export var low_sanity_dialogue: Array[String] = ["You look... different.", "Are you okay?"]
@export var has_choices: bool = false
@export var dialogue_choices: Dictionary = {}

var player_nearby = false
var animation_reset_timer: Timer = Timer.new()

@onready var sprite = $AnimatedSprite2D

@onready var dialogue_ui = get_node("../CanvasLayer/TestDialogueUi")

func _ready():
	sprite.frames = animations  # Set animations dynamically
	sprite.play("idle_up")  # Default to idle animation
	
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_body_exited"))
	
	animation_reset_timer.wait_time = 3.0
	animation_reset_timer.one_shot = true
	add_child(animation_reset_timer)
	animation_reset_timer.connect("timeout", Callable(self, "_reset_idle_animation"))

func _on_body_entered(body):
	if body.name == "Player":
		player_nearby = true

func _on_body_exited(body):
	if body.name == "Player":
		player_nearby = false

func _process(delta):
	if player_nearby and Input.is_action_just_pressed("player_interact"):
		print("Interacting with NPC")
		start_dialogue()

func start_dialogue():
	sprite.play("idle_down")  # Play talking animation
	animation_reset_timer.stop()
	var sanity = PlayerStats.sanity
	var dialogue = default_dialogue if sanity > 50 else low_sanity_dialogue
	var message = dialogue[randi() % dialogue.size()]  # Pick a random dialogue line
	
	if dialogue_ui:
		print("Dialogue UI detected, triggering show_dialogue()")
		dialogue_ui.show_dialogue(npc_name, message)
		dialogue_ui.dialogue_ended.connect(_on_dialogue_end)

func _reset_idle_animation():
	sprite.play("idle_up")
	
func _on_dialogue_end():
	animation_reset_timer.start()
