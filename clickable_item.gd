extends Area3D

@export var clicks_required: int = 500
@export var spawn_scene: PackedScene
@export var spawn_point: Node3D  # Нода, по которой определяем позицию появления
@onready var door_mesh = get_node("../Door")

var current_clicks: int = 0

func interact():
	current_clicks += 1
	
	if current_clicks >= clicks_required:
		var spawn_pos = spawn_point.global_transform.origin
		door_mesh.queue_free()
		_spawn_next(spawn_pos)
		queue_free()


func _spawn_next(spawn_pos: Vector3):
	if spawn_scene:
		var instance = spawn_scene.instantiate()
		instance.global_transform.origin = spawn_pos
		instance.rotation_degrees.z = 90  # поворот на 90 по Z
		instance.scale = Vector3(0.5, 0.5, 0.5)  # масштаб
		get_tree().current_scene.add_child(instance)
