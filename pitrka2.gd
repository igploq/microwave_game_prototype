extends Node3D

@onready var pila_rot = $AnimationPlayer

func _ready() -> void:
	pila_rot.play("new_animation")
