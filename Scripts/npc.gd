extends CharacterBody2D

@export var npc_name: String
@export var animations: SpriteFrames

@export var dialogue_file: String = "res://Scripts/dialogue.dialogue" # Path to dialogue file
@export var dialogue_start: String = "start" # Entry point in dialogue file

@export var normal_dialogue: String = "res://Scripts/dialogue_normal.dialogue"
@export var insane_dialogue: String = "res://Scripts/dialogue_insane.dialogue"
@export var start_point: String = "start"

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("Player")
var player_nearby = false
var animation_reset_timer: Timer = Timer.new()

@onready var sprite = $AnimatedSprite2D

@onready var dialogue_ui = get_node("../CanvasLayer/TestDialogueUi")
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
		return  # Prevent multiple interactions at once

	in_dialogue = true  # Set dialogue active

	# Determine sanity level and select appropriate dialogue file
	var dialogue_file = normal_dialogue if PlayerStats.get_sanity() >= 50 else insane_dialogue

	# Change animation to talking
	animated_sprite.play("idle_down")

	# Show the dialogue balloon
	DialogueManager.show_dialogue_balloon_scene(
		load("res://Scripts/Balloon/balloon.tscn"),
		load(dialogue_file),
		start_point
	)

	# Wait for dialogue to finish
	await DialogueManager.dialogue_ended

	# Restore animation and allow movement again
	animated_sprite.play("idle_up")
	in_dialogue = false

func _on_dialogue_finished():
	in_dialogue = false
	animated_sprite.play("idle_up") # Return to idle animation
	player.set_process_input(true) # Re-enable player movement

func _reset_idle_animation():
	sprite.play("idle_up")
	
func _on_dialogue_end():
	animation_reset_timer.start()
