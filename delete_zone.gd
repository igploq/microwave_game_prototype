extends Area3D

@onready var processing_area = get_tree().get_root().get_node("Game/Microwave/ProcessingArea") # путь до ProcessingArea

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area3D) -> void:
	var item = area.get_parent()

	# Проверка: активен ли запрос
	if processing_area.is_request_active:
		var required_item = processing_area.items[processing_area.required_item_index].instantiate()
		var required_name = required_item.item_name
		required_item.free()

		if item.item_name == required_name:
			# Нужный предмет был удалён! Штраф
			var player = get_tree().get_root().get_node("Game/Player")
			player.apply_damage(1)

	item.queue_free()
