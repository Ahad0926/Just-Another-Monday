# Display time in small phone UI (always visible)
extends Control

var current_time = "Day 1 - 8:00 AM"  # Placeholder for in-game time

func _process(delta):
	# Update the time in the label
	$PhoneTimeLabel.text = current_time  # Assuming you have a label node for time
