extends Node2D

@export var dialogue_file: String = ""  # Assign different dialogue files per object
@export var start_point: String = "start"  # Assign different dialogue start points
@export var interaction_text: String = "Interact"  # Optional UI prompt

@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var player = get_tree().get_first_node_in_group("Player")

var player_nearby = false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		player_nearby = true
		print("Player near:", name)

func _on_body_exited(body):
	if body.name == "Player":
		player_nearby = false
		print("Player left:", name)

func _process(_delta):
	if player_nearby and Input.is_action_just_pressed("player_interact"):
		start_dialogue()

func start_dialogue():
	if dialogue_file.is_empty():
		print("No dialogue file assigned to", name)
		return

	print("Starting dialogue for", name)
	
	# Load and display the assigned dialogue
	DialogueManager.show_dialogue_balloon_scene(
		load("res://Scripts/Balloon/balloon.tscn"),
		load(dialogue_file),
		start_point
	)
