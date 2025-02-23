extends Node

var emails = [
	{
		"id": 1,
		"title": "Welcome to Work!",
		"sender": "HR Department",
		"body": "Hello and welcome to your first day! Please get started by completing the task in the 'Folders' app.",
		"task": "organize_folders",
		"completed": false
	},
	{
		"id": 2,
		"title": "Urgent Report Needed",
		"sender": "Boss",
		"body": "Hey, I need you to generate a report by sorting the files in the correct folders.",
		"task": "generate_report",
		"completed": false
	},
	{
		"id": 3,
		"title": "Strange System Log",
		"sender": "Unknown",
		"body": "There’s something odd happening in the system. Have you noticed any glitches?",
		"task": "read_log",
		"completed": false
	}
]

func mark_email_completed(email_id):
	for email in emails:
		if email["id"] == email_id:
			email["completed"] = true
			break
