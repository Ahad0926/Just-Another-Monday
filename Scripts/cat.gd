extends CharacterBody2D

@export var npc_name: String
@export var animations: SpriteFrames

@export var dialogue_files: Array[String] = [
	"res://Scripts/dialogue/cat_intro.dialogue",
	"res://Scripts/dialogue/cat_dialogue_2.dialogue"
]  # List of dialogues that will progress over time

@export var start_point: String = "start"
var dialogue_index = 0

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("Player")
var player_nearby = false
var animation_reset_timer: Timer = Timer.new()

@onready var sprite = $AnimatedSprite2D


var in_dialogue = false
func _ready():
	animated_sprite.play("idle_up")
	
	$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))
	$Area2D.connect("body_exited", Callable(self, "_on_body_exited"))
	
	animation_reset_timer.wait_time = 3.0
	animation_reset_timer.one_shot = true
	add_child(animation_reset_timer)
	animation_reset_timer.connect("timeout", Callable(self, "_reset_idle_animation"))

func _on_body_entered(body):
	if body.name == "Player":
		player_nearby = true
		body.near_npc = self

func _on_body_exited(body):
	if body.name == "Player":
		player_nearby = false
		body.near_npc = self

func _process(delta):
	if player_nearby and Input.is_action_just_pressed("player_interact"):
		print("Interacting with NPC")
		interact()

func interact():
	if in_dialogue:
		return  # Prevent multiple interactions

	in_dialogue = true  # Mark dialogue as active
	player.enter_dialogue_mode()  # Stops player movement

	# Change animation to talking (switch between resting and mischevious)
	animated_sprite.play("idle_mischevious")

	# Load the correct dialogue file
	var dialogue_file = dialogue_files[dialogue_index]

	# Show the dialogue balloon
	DialogueManager.show_dialogue_balloon_scene(
		load("res://Scripts/Balloon/balloon.tscn"),
		load(dialogue_file),
		start_point
	)

	# Wait for dialogue to finish
	await DialogueManager.dialogue_ended

	# Increment dialogue index so the next interaction loads the next dialogue
	if dialogue_index < dialogue_files.size() - 1:
		dialogue_index += 1  

	# Reset animation and allow player movement
	animated_sprite.play("idle_resting")
	player.exit_dialogue_mode()
	in_dialogue = false

func _on_dialogue_finished():
	in_dialogue = false
	animated_sprite.play("idle_up") # Return to idle animation
	player.set_process_input(true) # Re-enable player movement

func _reset_idle_animation():
	sprite.play("idle_up")
	
func _on_dialogue_end():
	animation_reset_timer.start()
