extends Area3D

@export var speed_increase: float = 2.0
var items_in_zone: Array[Node3D] = []
var is_active: bool = true # Активна ли зона для взаимодействия

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	# Подключаемся к сигналам микроволновки
	var microwave = get_node("/root/Game/Microwave/ProcessingArea")
	microwave.microwave_filled.connect(_on_microwave_filled)
	microwave.microwave_request.connect(_on_microwave_request)

func _on_area_entered(area: Area3D) -> void:
	var item = area.get_parent()
	if item not in items_in_zone:
		items_in_zone.append(item)

func _on_area_exited(area: Area3D) -> void:
	var item = area.get_parent()
	items_in_zone.erase(item)

func _process(_delta: float) -> void:
	if is_active and Input.is_action_just_pressed("interact"):
		if items_in_zone.size() > 0:
			var item = items_in_zone[0]
			item.direction = item.direction.rotated(Vector3.UP, deg_to_rad(-90))
			item.speed += speed_increase

func _on_microwave_filled() -> void:
	is_active = false

func _on_microwave_request() -> void:
	is_active = true
