class_name DayNightCycle extends CanvasModulate

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

signal time_tick(day:int, hour:int, minute:int)

@export var gradient_texture: GradientTexture1D
@export var INGAME_SPEED = 20.0
@export var INITIAL_HOUR = 12:
	set(h):
		INITIAL_HOUR = h
		time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * INITIAL_HOUR

var time: float = 0.0
var past_minute: int = -1
var frozen_time: float = -1.0
var frozen_gradient: Color = Color(1, 1, 1)

func _ready() -> void:
	time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * INITIAL_HOUR

func _process(delta: float) -> void:
	# Only update time if it's not frozen
	if frozen_time == -1.0:
		time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	
	var value = (sin(time - PI / 2.0) + 1.0) / 2.0
	self.color = gradient_texture.gradient.sample(value)
	
	_recalculate_time()	

func _recalculate_time() -> void:
	var total_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	
	var day = int(total_minutes / MINUTES_PER_DAY)
	var current_day_minutes = total_minutes % MINUTES_PER_DAY
	
	var hour = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if past_minute != minute:
		past_minute = minute
		time_tick.emit(day, hour, minute)
		PlayerStats.stamina -= 0.0694
		#print("day: ", day, " hour: ", hour, " minute: ", minute)

# Function to freeze time
func freeze() -> void:
	frozen_time = time
	frozen_gradient = self.color
	print("Time frozen at: " + str(frozen_time))

# Function to unfreeze time
func unfreeze() -> void:
	if frozen_time != -1.0:
		time = frozen_time
		self.color = frozen_gradient
		frozen_time = -1.0  # Reset the frozen time state
		print("Time unfrozen, resumed from: " + str(time))
