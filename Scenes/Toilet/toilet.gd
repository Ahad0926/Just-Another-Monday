extends BaseScene

@onready var pee_bar: TextureProgressBar = $TextureProgressBar
@onready var pee_timer: Timer = $PeeTimer
@onready var pee_stream: CPUParticles2D = $CPUParticles2D


var pee_step := 1.0  # how much to reduce per tick
var pee_interval := 0.1  # how often to reduce (seconds)

var peeing := false

func _ready() -> void:
	super()
	pee_bar.max_value = 100
	pee_bar.value = pee_bar.max_value

	pee_timer.wait_time = pee_interval
	pee_timer.connect("timeout", _on_pee_timer_timeout)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_peeing()
		else:
			_stop_peeing()

func _process(_delta: float) -> void:
	if peeing:
		aim_pee_stream_at_mouse()

func _start_peeing() -> void:
	if not peeing:
		peeing = true
		pee_timer.start()
		pee_stream.emitting = true
		print("Started peeing")

func _stop_peeing() -> void:
	if peeing:
		peeing = false
		pee_timer.stop()
		pee_stream.emitting = false
		print("Stopped peeing")

func _on_pee_timer_timeout() -> void:
	if peeing and pee_bar.value > 0:
		pee_bar.value = max(pee_bar.value - pee_step, 0)
		if pee_bar.value <= 0:
			peeing = false
			pee_timer.stop()
			pee_stream.emitting = false
			_on_pee_finished()

func _on_pee_finished() -> void:
	print("Finished peeing!")
	PlayerStats.stress -= 10
	scene_manager.change_scene(self, "Apartment/apartment")

func aim_pee_stream_at_mouse() -> void:
	var global_mouse_pos = get_viewport().get_mouse_position()
	var direction = (global_mouse_pos - pee_stream.global_position).normalized()

	var gravity_strength = pee_stream.gravity.length()
	pee_stream.gravity = direction * gravity_strength
