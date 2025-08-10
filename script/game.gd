extends Node2D

# ANIMATIONS
@onready var ButtonAnimationIDLEPlayer = $Animations/anim_GButtonIdle
@onready var ButtonAnimationCLICKPlayer = $Animations/anim_GButtonClick

# OBJECTS 
@onready var gCounter = $obj_gCounter
@onready var gpsCounter = $obj_gpsCounter
@onready var gsound = $SOUNDS/g_collect

# PARTICLES
@export var clickParticle : PackedScene

# SCENES
@export_file("*.tscn") var shop_scene: String

signal loaded()

func _ready() -> void:
	ButtonAnimationIDLEPlayer.play("anim_GBIdle")
	pass

func _onclick():
	if ButtonAnimationCLICKPlayer.is_playing() == true:
		ButtonAnimationCLICKPlayer.stop()
	ButtonAnimationCLICKPlayer.play("anim_GBClick2")
	
	Global._addGs(Global.data["player"]["gPerClick"])
	
	var _particle = clickParticle.instantiate()
	_particle.position = get_global_mouse_position()
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	
	gsound.play()
	
	# queue_free()

func _process(delta: float) -> void:
	gpsCounter.text = Global.abreviateNum(Global.data["player"]["gPerSecond"]) + " gps"
	
	if Global.displayed_g < Global.data["player"]["gAmount"]:
		var difference = Global.data["player"]["gAmount"] - Global.displayed_g
		
		var step = max(100, difference * 10) * delta
		Global.displayed_g += step
		
		if Global.displayed_g > Global.data["player"]["gAmount"]:
			Global.displayed_g = Global.data["player"]["gAmount"]
			
		gCounter.text = Global.abreviateNum(Global.displayed_g) + " g's"
	else:
		gCounter.text = Global.abreviateNum(Global.displayed_g) + " g's"
	pass


func _on_shop_click() -> void:
	SceneManager.transition_to(shop_scene)
	
func load_scene() -> void:
	await get_tree().create_timer(2.0).timeout
	loaded.emit()
