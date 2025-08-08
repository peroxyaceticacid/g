extends Node

@onready var thing = $background

func _ready() -> void:
	thing.play("loop")
