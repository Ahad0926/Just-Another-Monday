extends Panel

@onready var close_button = $CloseButton
@onready var email_list = $VBoxContainer

func _ready():
	visible = false
	close_button.pressed.connect(_close_app)
	populate_email_list()

func populate_email_list():
	for child in email_list.get_children():
		email_list.remove_child(child)
		child.queue_free()


	for email in EmailData.emails:
		if not email["completed"]:  # Only show incomplete tasks
			var email_button = Button.new()
			email_button.text = email["title"] + " - " + email["sender"]
			email_button.connect("pressed", Callable(self, "_open_email").bind(email))
			email_list.add_child(email_button)

func _open_email(email):
	var email_popup = ConfirmationDialog.new()
	email_popup.dialog_text = "From: " + email["sender"] + "\n\n" + email["body"]
	email_popup.ok_button_text = "Close"
	add_child(email_popup)
	email_popup.popup_centered()

func _close_app():
	visible = false
