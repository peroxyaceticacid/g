extends Node2D

@onready var background = $background
@onready var background2 = $background2
@onready var forground2 = $foreground2
@onready var foreground = $foreground

# the higher the value, the slower it goes
var speed = .5

func _setpos(obj, difference, dt):
	obj.position += (get_global_mouse_position() / (speed + difference) * dt) - obj.position

func _physics_process(delta: float) -> void:
	_setpos(background, 0, delta)
	_setpos(background2, 1, delta)
	_setpos(forground2, 2, delta)
	_setpos(foreground, 3, delta)
	
