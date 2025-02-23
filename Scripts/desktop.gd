extends Node

@onready var email_window = $EmailAppWindow
@onready var email_button = $EmailAppButton/TextureButton

func _ready():
	email_button.pressed.connect(_open_email)

func _open_email():
	email_window.visible = true
	EmailData.current_email_index = 0  # Reset index when reopened
