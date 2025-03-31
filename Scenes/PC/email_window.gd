extends Panel

@onready var title_label = $Title
@onready var sender_label = $Sender
@onready var body_label = $Body


@onready var flag_spam_button = $FlagSpam
@onready var mark_safe_button = $MarkSafe

@onready var close_button = $CloseButton

var current_email

func _ready():
	close_button.pressed.connect(_close_app)
	flag_spam_button.pressed.connect(_flag_as_spam)
	mark_safe_button.pressed.connect(_mark_as_safe)
	load_next_email()

func load_next_email():
	if EmailData.current_email_index < EmailData.total_emails:
		current_email = EmailData.emails[EmailData.current_email_index]
		title_label.text = current_email["title"]
		sender_label.text = current_email["sender"]
		body_label.text = current_email["body"]
	else:
		get_mystery_email()
		end_game()

func get_mystery_email():
	var stylebox := StyleBoxTexture.new()
	stylebox.texture = preload("res://Assets/PC/Inbox/inbox_spam_bg.png")
	self.add_theme_stylebox_override("panel", stylebox)

func _flag_as_spam():
	check_answer(true)

func _mark_as_safe():
	check_answer(false)

func check_answer(player_choice):
	var correct = (player_choice == current_email["is_spam"])
	
	# Flash color feedback
	var original_color = modulate
	modulate = Color(0, 1, 0) if correct else Color(1, 0, 0)
	await get_tree().create_timer(0.3).timeout
	modulate = original_color
	
	# Update score if correct
	if correct:
		EmailData.correct_sort_count += 1
	
	# Move to next email
	EmailData.current_email_index += 1
	load_next_email()

func end_game():
	title_label.text = "Sorting Complete!"
	sender_label.text = "Correct Emails Sorted: " + str(EmailData.correct_sort_count) + "/" + str(EmailData.total_emails)
	body_label.text = "Great job! You finished reviewing all emails."
	flag_spam_button.visible = false
	mark_safe_button.visible = false
	GameState.emails_done = true
	PlayerStats.stress += 20
	PlayerStats.stamina -= 20

func _close_app():
	visible = false
