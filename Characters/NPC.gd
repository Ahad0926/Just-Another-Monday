extends Node2D

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var default_facing_anim := "Down"  # change based on your animation setup

func face_direction(from_pos: Vector2) -> void:
	var dir = (from_pos - global_position).normalized()

	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			_set_facing("Right")
		else:
			_set_facing("Left")
	else:
		if dir.y > 0:
			_set_facing("Down")
		else:
			_set_facing("Up")

func _set_facing(direction: String) -> void:
	var anim_name = "Idle " + direction
	if anim_player:
		anim_player.play(anim_name)

func reset_facing() -> void:
	_set_facing(default_facing_anim)
