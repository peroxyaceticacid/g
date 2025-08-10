extends CanvasLayer

signal transitioned_in()
signal transitioned_out()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dude: TextureRect = $TextureRect

func transition_in() -> void:
	animation_player.play("in")
	
func transition_out() -> void:
	create_tween().tween_property(dude, "position", Vector2(1062.0, 754.0), .3)
	animation_player.play("out")
	
func transition_to(scene: String) -> void:
	transition_in()
	await transitioned_in
	
	var new_scene = load(scene).instantiate()
	var root: Window = get_tree().get_root()
	
	root.get_child(root.get_child_count() - 1).free()
	root.add_child(new_scene)
	get_tree().current_scene = new_scene
	
	new_scene.load_scene()
	await new_scene.loaded
	
	
	transition_out()
	await transitioned_out


func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "in":
		animation_player.play("load_dude")
		transitioned_in.emit()
	elif anim_name == "out":
		transitioned_out.emit()
