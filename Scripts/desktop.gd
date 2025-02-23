extends Node

@onready var email_window = $EmailAppWindow
#@onready var folders_window = $FoldersAppWindow
@onready var email_button = $EmailAppButton/TextureButton
#@onready var folders_button = $FoldersAppButton

func _ready():
	email_button.pressed.connect(_open_email)
	#folders_button.pressed.connect(_open_folders)

func _open_email():
	email_window.visible = true

func _open_folders():
	pass#folders_window.visible = true
