extends CharacterBody2D

@export var speed: float = 80.0

func _physics_process(delta):
	var direction = Vector2.ZERO

	# Detect Input (use separate if-statements to allow diagonal movement)
	if Input.is_action_pressed("player_right"):
		direction.x += 1
	if Input.is_action_pressed("player_left"):
		direction.x -= 1
	if Input.is_action_pressed("player_down"):
		direction.y += 1
	if Input.is_action_pressed("player_up"):
		direction.y -= 1

	# Normalize for smooth diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()

		# Update animation based on direction
		if direction.x > 0:
			$AnimatedSprite2D.play("walk_right")
		elif direction.x < 0:
			$AnimatedSprite2D.play("walk_left")
		elif direction.y > 0:
			$AnimatedSprite2D.play("walk_down")
		elif direction.y < 0:
			$AnimatedSprite2D.play("walk_up")
	else:
		# Play idle animation based on last movement
		match $AnimatedSprite2D.animation:
			"walk_right": $AnimatedSprite2D.play("idle_right")
			"walk_left": $AnimatedSprite2D.play("idle_left")
			"walk_down": $AnimatedSprite2D.play("idle_down")
			"walk_up": $AnimatedSprite2D.play("idle_up")

	# Apply velocity and movement
	velocity = direction * speed
	move_and_slide()
