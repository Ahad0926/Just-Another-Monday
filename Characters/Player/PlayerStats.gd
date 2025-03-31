extends Node

signal stats_updated(stamina: float, stress: float)

var max_stamina: float = 100.0
var max_stress: float = 100.0

var stamina: float = max_stamina:
	set(value):
		stamina = clamp(value, 0, max_stamina)
		stats_updated.emit(stamina, stress)

var stress: float = 33.0:
	set(value):
		stress = clamp(value, 0, max_stress)
		stats_updated.emit(stamina, stress)

func reset_stats():
	stamina = max_stamina
	stress = 33.0
