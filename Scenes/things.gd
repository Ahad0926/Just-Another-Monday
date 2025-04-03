extends Node2D

var interactables := []

@onready var player_interacting_component = get_tree().get_first_node_in_group("player_interacting_component")


func _ready() -> void:
	# Automatically gather all interactable children under "Things"
	for child in get_children():
		if child is Area2D and child.has_method("interact"):
			interactables.append(child)

	# Connect interaction_occurred signal from player's interacting_component
	if player_interacting_component:
		player_interacting_component.interaction_occurred.connect(_on_interaction)
	else:
		print("poop")

func _on_interaction(interactable):
	print("Interacted with:", interactable.interact_name)  # Print interactable's name

	if interactable.interact_name == "Check Closet":
		print("Closet dialogue triggered!")
	elif interactable.interact_name == "Check Sink":
		print("Sink dialogue triggered!")
	elif interactable.interact_name == "Pick Item":
		print("Picked up:", interactable.interact_name)
