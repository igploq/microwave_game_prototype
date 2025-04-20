extends Area3D

@export var items: Array[PackedScene] = []
@export var required_item_index: int = 0
@export var max_items: int = 5
@export var pause_between_requests: float = 30.0
@export var label_3d: Label3D

var score: int = 0
var item_speed: float = 2.0
var speed_increase: float = 0.5

signal microwave_filled
signal microwave_request

@onready var microwave_anim = $"../Door/DoorOpener"
var pause_timer: Timer
var is_request_active: bool = true

func _ready() -> void:
	area_entered.connect(_on_area_entered)

	pause_timer = Timer.new()
	pause_timer.one_shot = true
	pause_timer.autostart = false
	pause_timer.wait_time = pause_between_requests
	add_child(pause_timer)
	pause_timer.timeout.connect(_on_pause_timer_timeout)

	reset_request()

func reset_request() -> void:
	if items.is_empty():
		return
	if required_item_index >= items.size():
		return

	is_request_active = true
	score = 0
	item_speed += speed_increase

	var required_item = items[required_item_index].instantiate()
	var required_name = required_item.item_name
	required_item.free()

	microwave_anim.play("door_open")
	_update_label(required_name)


func _on_area_entered(area: Area3D) -> void:
	var item = area.get_parent()
	if score >= max_items:
		print("Лимит достигнут: ", score, "/", max_items)
		return

	if required_item_index < items.size():
		var required_item = items[required_item_index].instantiate()
		var required_name = required_item.item_name
		required_item.free()

		if item.item_name == required_name:
			score += 1

			_update_label(required_name)

			if score >= max_items:
				microwave_anim.play("door_close")

				is_request_active = false
				emit_signal("microwave_filled")
				pause_timer.start()
		else:
			if is_request_active:
				var player = get_tree().get_root().get_node("Game/Player")
				player.apply_damage(1)


func _on_pause_timer_timeout() -> void:
	required_item_index = randi() % items.size()
	max_items = randi_range(2, 5)
	is_request_active = true
	reset_request()
	emit_signal("microwave_request")

func _update_label(item_name: String) -> void:
	if label_3d:
		label_3d.text = "%s: %d / %d" % [item_name, score, max_items]
