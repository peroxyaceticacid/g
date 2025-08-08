extends TextureButton

# the higher the value, the slower it goes
var speed = .5

func _physics_process(delta: float) -> void:
	position += ((get_global_mouse_position() / (speed + 2.8) * delta) - position) - Vector2(0,-340)
