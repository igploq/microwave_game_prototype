extends Node2D

@onready var sound = $Shotgun

func _ready() -> void:
	sound.play()
