extends Node3D

@export var items: Array[PackedScene] = []
@export var spawn_point: Node3D
@export var spawn_interval: float = 1.0
var timer: float = 0.0
var pause_timer: Timer

func _ready() -> void:
	if items.is_empty():
		push_error("Массив предметов пуст! Добавьте префабы в инспекторе.")
	if not spawn_point:
		push_error("SpawnPoint не назначен! Укажите Node3D в инспекторе.")
		
	pause_timer = Timer.new()
	pause_timer.wait_time = 30.0
	pause_timer.one_shot = true
	pause_timer.autostart = false
	add_child(pause_timer)
	pause_timer.timeout.connect(_on_pause_timer_timeout)

	var microwave = get_node("/root/Game/Microwave/ProcessingArea")
	microwave.microwave_filled.connect(_on_microwave_filled)
	microwave.microwave_request.connect(_on_microwave_request) # <--- ВАЖНО


func _process(delta: float) -> void:
	if items.is_empty() or not spawn_point:
		return
	timer += delta
	if timer >= spawn_interval:
		spawn_item()
		timer = 0.0

func spawn_item() -> void:
	var random_item: PackedScene = items[randi() % items.size()]
	var item_instance = random_item.instantiate()
	get_tree().root.add_child(item_instance)
	item_instance.global_position = spawn_point.global_position

func _on_microwave_filled() -> void:
	set_process(false)
	pause_timer.start()

func _on_pause_timer_timeout() -> void:
	set_process(true)
	var microwave = get_node("/root/Game/Microwave/ProcessingArea")
	microwave.reset_request() # Вызываем сброс и новый запрос

func _on_microwave_request() -> void:
	set_process(true)
