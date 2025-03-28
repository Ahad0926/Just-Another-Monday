extends BaseScene

@onready var email_window = $Control/EmailAppWindow
@onready var email_button = $Control/EmailAppButton/TextureButton
@onready var start_button = $Control/Taskbar/StartButton  # Get the Start Button node
func _ready():
	position_player()
	sync_time()
	player.freeze()
	email_button.pressed.connect(_open_email)
	start_button.pressed.connect(_exit_desktop)  # Connect Start Button to exit function

func _open_email():
	email_window.visible = true
	EmailData.current_email_index = 0  # Reset index when reopened

func _exit_desktop():
	print("Exiting desktop, returning to apartment...")
	player.unfreeze()
	scene_manager.change_scene(self,"Apartment/apartment")
