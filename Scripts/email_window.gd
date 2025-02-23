extends Panel

@onready var close_button = $CloseButton

func _ready():
	close_button.pressed.connect(_close_app)

func _close_app():
	visible = false
