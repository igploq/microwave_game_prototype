extends Area3D

@export var scene_to_load: PackedScene
@export var use_delay: bool = false
@export var delay_time: float = 5.0

func interact():

	if use_delay:
		await get_tree().create_timer(delay_time).timeout

	if scene_to_load:
		get_tree().change_scene_to_packed(scene_to_load)
