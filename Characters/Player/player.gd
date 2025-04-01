class_name Player extends CharacterBody2D

@export var speed: float = 80
@export var can_input: bool = true

@onready var animationTree = $AnimationTree
@onready var state_machine = animationTree["parameters/playback"]
@onready var actionable_finder: Area2D = $Direction/ActionableFinder

@onready var canvas_modulate = $"../CanvasModulate"
@onready var time_ui = $"../Camera2D/CanvasLayer/DayNightCycleUI"

var input_vector: Vector2 = Vector2.ZERO

var blend_position: Vector2 = Vector2.ZERO
var blend_pos_paths = [
	"parameters/idle/idle_bs2d/blend_position",
	"parameters/walk/walk_bs2d/blend_position"
]
var animTree_state_keys = [
	"idle",
	"walk"
]

func _unhandled_input(event: InputEvent) -> void:
	canvas_modulate.unfreeze()
	time_ui.show()
	
	if can_input:
		var new_input_vector := Vector2.ZERO

		if Input.is_action_pressed("player_left"):
			new_input_vector.x -= 1
		if Input.is_action_pressed("player_right"):
			new_input_vector.x += 1
		if Input.is_action_pressed("player_up"):
			new_input_vector.y -= 1
		if Input.is_action_pressed("player_down"):
			new_input_vector.y += 1

		# Normalize input to avoid diagonal speed issues
		input_vector = new_input_vector.normalized()

		# Check for interaction with actionable areas
		if Input.is_action_pressed("player_interact") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var actionables = actionable_finder.get_overlapping_areas()
			
			if actionables.size() > 0:
				freeze()
				#canvas_modulate.freeze()
				actionables[0].action()
				await unfreeze()
				return

func _physics_process(delta: float) -> void:
	# Update velocity based on input
	velocity = input_vector * speed
	move_and_slide()

	# Handle animations based on input (even if movement is blocked)
	if input_vector.length() > 0:  # Even if velocity is zero, check for input
		_update_animation(input_vector)
	else:
		_set_idle_animation()

func _update_animation(direction: Vector2) -> void:
	blend_position = direction
	state_machine.travel("walk")  # Walk animation when moving or attempting to move
	animationTree.set(blend_pos_paths[1], blend_position)

func _set_idle_animation() -> void:
	# Switch to idle animation when not moving
	state_machine.travel("idle")
	animationTree.set(blend_pos_paths[0], blend_position)

# Method to block input and set velocity to 0
func freeze() -> void:
	print("\nplayer frozen!")
	can_input = false
	input_vector = Vector2.ZERO

func unfreeze() -> void:
	print("\nplayer unfrozen!")
	can_input = true

func push(direction: Vector2, distance: float, duration: float) -> void:
	var start_pos = global_position
	var end_pos = start_pos + direction.normalized() * distance
	var elapsed = 0.0
	
	# Set initial animation direction
	_update_animation(direction)
	
	while elapsed < duration:
		var t = elapsed / duration
		global_position = start_pos.lerp(end_pos, t)
		elapsed += get_process_delta_time()
		await get_tree().process_frame
	
	# Ensure final position is exact and return to idle animation
	global_position = end_pos
	blend_position = direction
	_set_idle_animation()
