extends Control

signal dialogue_ended

@onready var player = get_tree().get_first_node_in_group("player")

@onready var _npc_name : Label = $VBoxContainer/Name
@onready var _dialogue : RichTextLabel = $VBoxContainer/RichTextLabel

func _ready():
	visible = false

func show_dialogue(speaker : String, line : String):
	print("show_dialogue() triggered")
	_npc_name.visible = (speaker != "")
	_npc_name.text = speaker
	_dialogue.text = line
	open()
	print(speaker + ": " + line)

func _input(event):
	if event.is_action_pressed("next_dialogue") and visible:
		close()
		dialogue_ended.emit()

func open():
	visible = true
	get_tree().call_group("player", "enter_dialogue_mode")

func close():
	visible = false
	get_tree().call_group("player", "exit_dialogue_mode")
