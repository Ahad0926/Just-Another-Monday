extends Control

@onready var stamina_label: Label = $VBoxContainer/StaminaLabel
@onready var sanity_label: Label = $VBoxContainer/SanityLabel

func _ready():
	# Connect to PlayerStats signal so UI updates dynamically
	PlayerStats.connect("stats_changed", _on_stats_changed)

	# Set initial values
	update_stats(PlayerStats.sanity, PlayerStats.stamina)

func _on_stats_changed(new_sanity: float, new_stamina: float):
	update_stats(new_sanity, new_stamina)

func update_stats(sanity: float, stamina: float):
	stamina_label.text = "Stamina: " + str(int(stamina))
	sanity_label.text = "Sanity: " + str(int(sanity))
