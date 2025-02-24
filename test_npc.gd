extends CharacterBody2D

@export var sprite_texture: Texture2D # Assign a different texture per NPC
@export var sprite_scale: Vector2 = Vector2(2, 2) # Customize size per NPC
@export var animations: Resource # Assign different animation sets
@export var idle_animation: String = "idle_down" # Default idle animation
@export var normal_dialogue: String = "res://Scripts/dialogue_normal.dialogue"
@export var insane_dialogue: String = "res://Scripts/dialogue_insanediaglogue.dialogue"
@export var start_point: String = "start"

@onready var animated_sprite = $AnimatedSprite2D
@onready var interaction_area = $Area2D
@onready var player = get_tree().get_first_node_in_group("Player")

var in_dialogue = false

func _ready():
	# Apply custom properties
	if sprite_texture:
		animated_sprite.sprite_frames.set_texture(sprite_texture)
	animated_sprite.scale = sprite_scale
	if animations:
		animated_sprite.sprite_frames = animations
	animated_sprite.play(idle_animation)

func _process(_delta):
	if in_dialogue:
		return

	if player and player_nearby() and Input.is_action_just_pressed("player_interact"):
		start_dialogue()

func player_nearby():
	return interaction_area.has_overlapping_bodies()

func start_dialogue():
	if in_dialogue:
		return

	in_dialogue = true
	player.enter_dialogue_mode() # Stop movement

	# Choose dialogue based on sanity
	var dialogue_file = normal_dialogue if player.sanity >= 50 else insane_dialogue

	# Set talking animation
	animated_sprite.play("idle_down")

	# Trigger dialogue
	DialogueManager.show_dialogue_balloon_scene(
		load("res://Scripts/Balloon/balloon.tscn"),
		load(dialogue_file),
		start_point
	)

	await DialogueManager.dialogue_ended

	# Restore NPC state
	animated_sprite.play(idle_animation)
	player.exit_dialogue_mode()
	in_dialogue = false
