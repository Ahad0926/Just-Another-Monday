extends CharacterBody2D

@export var speed := 150  # Player speed

var direction := Vector2.ZERO

@onready var sprite := $AnimatedSprite2D  # Reference the AnimatedSprite2D node

func _process(delta):
	direction = Vector2.ZERO  # Reset movement direction

	# Standard WASD movement
	if Input.is_action_pressed("player_up"):
		direction.y -= 1  # Move up
	if Input.is_action_pressed("player_down"):
		direction.y += 1  # Move down
	if Input.is_action_pressed("player_left"):
		direction.x -= 1  # Move left
		sprite.flip_h = true  # Flip sprite to face left
	if Input.is_action_pressed("player_right"):
		direction.x += 1  # Move right
		sprite.flip_h = false  # Face right

	# Normalize diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
		velocity = direction * speed
		sprite.play("run")  # Play run animation when moving
	else:
		velocity = Vector2.ZERO
		sprite.play("idle")  # Play idle animation when standing

	move_and_slide()
