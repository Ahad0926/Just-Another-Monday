extends BaseScene

@onready var pc_ui_scene := preload("res://Scenes/PC/pc_ui.tscn")  # ← update if path is different

# These will be set after the UI is added
var email_window
var email_button
var start_button

func _ready():
	super()

	await get_tree().process_frame  # wait for one frame to finish scene load

	# Dynamically instance and add the UI
	var ui_instance = pc_ui_scene.instantiate()
	add_child(ui_instance)
	ui_instance.z_index = 99  # make sure it's on top

	# Grab nodes from the instanced UI
	email_window = ui_instance.get_node("Control/EmailAppWindow")
	email_button = ui_instance.get_node("Control/EmailAppButton/TextureButton")
	start_button = ui_instance.get_node("Control/Taskbar/StartButton")

	# Connect signals
	email_button.pressed.connect(_open_email)
	start_button.pressed.connect(_exit_desktop)

func _open_email():
	email_window.visible = true
	EmailData.current_email_index = 0

func _exit_desktop():
	print("Exiting desktop, returning to apartment...")
	player.unfreeze()
	scene_manager.change_scene(self, "Apartment/apartment")
