extends BaseScene

@onready var sink_area: Area2D = $SinkArea

@onready var plates := [
	$SinkPlate1, $SinkPlate2, $SinkPlate3,
	$SinkPlate4, $SinkPlate5, $SinkPlate6
]

var dragging_plate: Node2D = null
var offset := Vector2.ZERO

func _ready() -> void:
	super()
	#time_canvas_layer.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				for plate in plates:
					if plate.get_rect().has_point(plate.to_local(event.position)):
						dragging_plate = plate
						offset = plate.global_position - event.position
						break
			else:
				if dragging_plate:
					if _is_over_sink(dragging_plate):
						print("Plate overlap!")
						_remove_plate(dragging_plate)
					dragging_plate = null

	elif event is InputEventMouseMotion and dragging_plate:
		dragging_plate.global_position = event.position + offset

func _is_over_sink(plate: Node2D) -> bool:
	# Find the Area2D child of the plate
	var plate_area := plate.get_node("Area2D")
	if not plate_area:
		return false

	var overlapping_areas = plate_area.get_overlapping_areas()
	print(overlapping_areas)
	return sink_area in overlapping_areas

func _remove_plate(plate: Node2D) -> void:
	plates.erase(plate)
	plate.queue_free()
	print("Plate removed. Remaining:", plates.size())

	if plates.is_empty():
		print("All plates done. Switching scene.")
		PlayerStats.stamina -= 10
		scene_manager.change_scene(self, "Apartment/apartment")
