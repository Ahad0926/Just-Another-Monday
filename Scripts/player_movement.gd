extends CharacterBody2D

@export var speed: float = 80.0
var player_stats = PlayerStats
@onready var animated_sprite = $AnimatedSprite2D

func _process(delta: float) -> void:
	_handle_input()

func _physics_process(delta: float) -> void:
	_update_movement()

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

	# Reduce stamina when moving
	player_stats.modify_stats(0, -0.1)

func _set_idle_animation() -> void:
	match animated_sprite.animation:
		"walk_right": animated_sprite.play("idle_right")
		"walk_left": animated_sprite.play("idle_left")
		"walk_down": animated_sprite.play("idle_down")
		"walk_up": animated_sprite.play("idle_up")
