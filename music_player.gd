extends SpotLight3D

@onready var music = $Music

func _ready() -> void:
	music.play()
