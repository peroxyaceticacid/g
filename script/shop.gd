extends Node2D

@onready var background = $Background_Shop
@onready var shlimbombo = $chr_schlimbombo

var price = 0.0

signal loaded

@export_file("*.tscn") var main_scene: String

func _physics_process(delta: float) -> void:
	background.position += ((get_global_mouse_position() / (.5) * delta) - background.position) - Vector2(150, 100)
	shlimbombo.position += ((get_global_mouse_position() / (.5 + 3) * delta) - shlimbombo.position) - Vector2(-450, -100)
	
func load_scene() -> void:
	await get_tree().create_timer(2.0).timeout
	loaded.emit()
	


func _on_exit() -> void:
	SceneManager.transition_to(main_scene)
