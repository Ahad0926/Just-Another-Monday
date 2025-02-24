extends Node

@onready var email_window = $EmailAppWindow
@onready var email_button = $EmailAppButton/TextureButton
@onready var start_button = $Taskbar/StartButton  # Get the Start Button node

const APARTMENT_SCENE = "res://Scenes/apartment2.tscn"  # Path to apartment scene

func _ready():
	email_button.pressed.connect(_open_email)
	start_button.pressed.connect(_exit_desktop)  # Connect Start Button to exit function

func _open_email():
	email_window.visible = true
	EmailData.current_email_index = 0  # Reset index when reopened

func _exit_desktop():
	print("Exiting desktop, returning to apartment...")
	get_tree().change_scene_to_file(APARTMENT_SCENE)  # Load the apartment scene
