extends Node

# Declare the variables for sanity and stamina
var sanity = 100 # The starting sanity, ranging from 0 to 100
var stamina = 100 # The starting stamina, ranging from 0 to 100

# Declare the rate at which stats will change
var sanity_decrease_rate = 0.1  # Rate of sanity decrease per time step or event
var stamina_decrease_rate = 0.2  # Rate of stamina decrease per time step

# Declare a signal for when stats change
signal stats_changed(new_sanity, new_stamina)

# Called every frame to update the stats
func _process(delta):
	# Decrease stamina as the day progresses (time passing, for example)
	if stamina > 0:
		#stamina -= stamina_decrease_rate * delta  # Decrease stamina over time
		stamina = max(stamina, 0)  # Ensure stamina doesn't go below 0
	
	# Decrease sanity based on player actions (investigating clues, skipping work, etc.)
	if sanity > 0:
		sanity = max(sanity, 0)  # Ensure sanity doesn't go below 0

	# Emit a signal whenever stats change
	emit_signal("stats_changed", sanity, stamina)

# Call this function to increase or decrease the sanity and stamina
func modify_stats(sanity_change: float, stamina_change: float):
	sanity += sanity_change
	stamina += stamina_change
	
	# Ensure sanity and stamina are clamped between 0 and 100
	sanity = clamp(sanity, 0, 100)
	stamina = clamp(stamina, 0, 100)
	
	# Emit a signal whenever stats are modified
	emit_signal("stats_changed", sanity, stamina)
	print("(", sanity, ", ", stamina, ")")

# To check current sanity and stamina
func get_sanity() -> int:
	return sanity

func get_stamina() -> int:
	return stamina
