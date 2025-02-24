extends CharacterBody2D

@export var speed: float = 80.0
@export var player_stats = PlayerStats
@onready var animated_sprite = $AnimatedSprite2D
@onready var dialogue_ui = get_tree().get_first_node_in_group("ExampleBalloon")
var in_dialogue = false
var using_pc = false
var near_pc = false
var input_vector: Vector2 = Vector2.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if in_dialogue or using_pc:
		_set_idle_animation()
		return  # Block movement during dialogue or PC use

	# Reset input vector before detecting new inputs
	var new_input_vector := Vector2.ZERO

	if Input.is_action_pressed("player_left"):
		new_input_vector.x -= 1
	if Input.is_action_pressed("player_right"):
		new_input_vector.x += 1
	if Input.is_action_pressed("player_up"):
		new_input_vector.y -= 1
	if Input.is_action_pressed("player_down"):
		new_input_vector.y += 1

	# Normalize to prevent increased diagonal movement speed
	input_vector = new_input_vector.normalized()

func _physics_process(delta: float) -> void:
	if in_dialogue or using_pc:
		velocity = Vector2.ZERO
		_set_idle_animation()
		return
	
	velocity = input_vector * speed
	move_and_slide()

	if velocity.length() > 0:
		_update_animation(input_vector)
	else:
		_set_idle_animation()

# Detect player input
func _handle_input() -> void:
	var direction := Vector2.ZERO

	if Input.is_action_pressed("player_right"):
		direction.x += 1
	if Input.is_action_pressed("player_left"):
		direction.x -= 1
	if Input.is_action_pressed("player_down"):
		direction.y += 1
	if Input.is_action_pressed("player_up"):
		direction.y -= 1

	if direction.length() > 0:
		direction = direction.normalized()
		_update_animation(direction)
	else:
		_set_idle_animation()  # NEW: Set idle animation if no input detected

	velocity = direction * speed

# Move the player
func _update_movement() -> void:
	velocity = velocity.normalized() * speed
	move_and_slide()

# Update animation based on movement direction
func _update_animation(direction: Vector2) -> void:
	if direction.x > 0:
		animated_sprite.play("walk_right")
	elif direction.x < 0:
		animated_sprite.play("walk_left")
	elif direction.y > 0:
		animated_sprite.play("walk_down")
	elif direction.y < 0:
		animated_sprite.play("walk_up")

	player_stats.modify_stats(0, -0.1)  # Reduce stamina when moving

func _set_idle_animation() -> void:
	match animated_sprite.animation:
		"walk_right": animated_sprite.play("idle_right")
		"walk_left": animated_sprite.play("idle_left")
		"walk_down": animated_sprite.play("idle_down")
		"walk_up": animated_sprite.play("idle_up")

func enter_dialogue_mode():
	in_dialogue = true
	velocity = Vector2.ZERO
	_set_idle_animation()

func exit_dialogue_mode():
	in_dialogue = false
		
var near_npc: CharacterBody2D = null

func _on_body_entered(body):
	if body.is_in_group("NPC"):
		print("Entered NPC area:", body.name)
		near_npc = body  # Assign NPC to near_npc

func _on_body_exited(body):
	if body.is_in_group("NPC"):
		print("Exited NPC area:", body.name)
		near_npc = null  # Remove reference when leaving
