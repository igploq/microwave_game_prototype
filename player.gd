extends CharacterBody3D

@export var mouse_sensitivity: float = 0.002

@onready var camera: Camera3D = $Camera3D
@onready var interaction_ray: RayCast3D = $Camera3D/InteractionRay
@onready var hit_area: Area3D = $Camera3D/HitArea
@onready var hit_timer: Timer = $HitTimer
@export var scene_to_load: PackedScene

var health: int = 3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.position = Vector3(0, 1.5, 0)

	# Отключаем HitArea при запуске
	hit_area.monitoring = false
	hit_area.connect("area_entered", Callable(self, "_on_hit_area_entered"))
	hit_timer.connect("timeout", Callable(self, "_on_hit_timeout"))

func _input(event):
	# Управление камерой
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)

	# Выход из захвата мыши
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Активация механизма (RayCast)
	if event.is_action_pressed("interact"):
		if interaction_ray.is_colliding():
			var collider = interaction_ray.get_collider()
			if collider and collider.is_in_group("item") and collider.get_parent() == get_tree().current_scene:
				collider.global_transform.origin = get_tree().current_scene.get_node("Microwave/ProcessingArea").global_transform.origin

	# Взаимодействие через HitArea
	if event.is_action_pressed("click"):
		hit_area.monitoring = true
		hit_timer.start(0.1) # включаем на 0.1 секунды

func _on_hit_area_entered(area: Area3D) -> void:
	if area.has_method("interact"):
		area.interact()

func _on_hit_timeout() -> void:
	hit_area.monitoring = false

func apply_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		get_tree().change_scene_to_packed(scene_to_load)
