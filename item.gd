extends Node3D

@export var speed: float = 2.0  # Базовая скорость на случай, если не нашли processing_area
@export var item_name: String = "Item"
var direction: Vector3 = Vector3.LEFT

func _process(delta: float) -> void:
	var area = get_node_or_null("/root/Main/ProcessingArea")  # путь к твоему processing_area
	if area and area.has_variable("item_speed"):
		position += direction * area.item_speed * delta
	else:
		position += direction * speed * delta
