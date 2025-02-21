extends Node

func show_message(npc_name: String, message: String):
	print(npc_name + ": " + message)  # Temporary console output for now

func show_choices(npc_name: String, message: String, choices: Dictionary):
	print(npc_name + ": " + message)
	for choice in choices.keys():
		print("-> " + choice)  # Show available choices in the console
