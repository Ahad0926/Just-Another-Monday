class_name DayNightCycleUI extends Control


@onready var day_label_background: Label = %DayLabelBackground
@onready var day_label: Label = %DayLabel
@onready var time_label_background: Label = %TimeLabelBackground
@onready var time_label: Label = %TimeLabel
@onready var stamina_bar: TextureProgressBar = $StaminaBar
@onready var stress_bar: TextureProgressBar = $StressBar

func _ready() -> void:
	PlayerStats.stats_updated.connect(_update_bars)
	_update_bars(PlayerStats.stamina, PlayerStats.stress)  # Initialize
	
func _update_bars(stamina: float, stress: float) -> void:
	stamina_bar.value = stamina
	stress_bar.value = stress

func set_daytime(day: int, hour: int, minute: int) -> void:
	var day_names = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
	var day_text = day_names[day % 7]  # Use modulo to cycle through days of the week
	day_label.text = day_text + " " + str(day + 1)
	day_label_background.text = day_label.text

	
	time_label.text = _amfm_hour(hour) + ":" + _minute(minute) + " " + _am_pm(hour)
	time_label_background.text = time_label.text
	
	# Update GameState global vars
	GameState.current_day = day
	GameState.current_hour = hour
	GameState.current_minute = minute


func _amfm_hour(hour:int) -> String:
	if hour == 0:
		return str(12)
	if hour > 12:
		return str(hour - 12)
	return str(hour)


func _minute(minute:int) -> String:
	if minute < 10:
		return "0" + str(minute)
	return str(minute)


func _am_pm(hour:int) -> String:
	if hour < 12:
		return "am"
	else:
		return "pm"


func _remap_rangef(input:float, minInput:float, maxInput:float, minOutput:float, maxOutput:float):
	return float(input - minInput) / float(maxInput - minInput) * float(maxOutput - minOutput) + minOutput
