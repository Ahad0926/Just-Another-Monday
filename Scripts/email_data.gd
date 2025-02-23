extends Node

# Example emails
var emails = [
	{"title": "Project Update", "sender": "Boss", "body": "Please review the project report.", "is_spam": false},
	{"title": "YOU WON A MILLION DOLLARS!", "sender": "SpamBot", "body": "Click here to claim your prize!", "is_spam": true},
	{"title": "Meeting Reminder", "sender": "HR", "body": "Don't forget about the meeting at 3PM.", "is_spam": false},
	{"title": "URGENT: Security Alert", "sender": "Admin", "body": "Your password was compromised. Reset now.", "is_spam": false},
	{"title": "FREE VACATION!", "sender": "Scammer", "body": "You've won a free trip to Hawaii!", "is_spam": true},
]

# Track progress
var current_email_index = 0
var correct_sort_count = 0
var total_emails = emails.size()
