extends Node2D

# ANIMATIONS
@onready var ButtonAnimationIDLEPlayer = $Animations/anim_GButtonIdle
@onready var ButtonAnimationCLICKPlayer = $Animations/anim_GButtonClick

# OBJECTS 
@onready var gCounter = $obj_gCounter
@onready var gpsCounter = $obj_gpsCounter

# PARTICLES
@export var clickParticle : PackedScene

func _ready() -> void:
	ButtonAnimationIDLEPlayer.play("anim_GBIdle")
	pass

func _onclick():
	if ButtonAnimationCLICKPlayer.is_playing() == true:
		ButtonAnimationCLICKPlayer.stop()
	ButtonAnimationCLICKPlayer.play("anim_GBClick2")
	
	Global._addGs(Global.data["gPerClick"])
	
	var _particle = clickParticle.instantiate()
	_particle.position = get_global_mouse_position()
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	
	# queue_free()

func _process(delta: float) -> void:
	gpsCounter.text = Global.abreviateNum(Global.data["gPerSecond"]) + " gps"
	
	if Global.displayed_g < Global.data["gAmount"]:
		var difference = Global.data["gAmount"] - Global.displayed_g
		
		var step = max(100, difference * 10) * delta
		Global.displayed_g += step
		
		if Global.displayed_g > Global.data["gAmount"]:
			Global.displayed_g = Global.data["gAmount"]
			
		gCounter.text = Global.abreviateNum(Global.displayed_g) + " g's"
	else:
		gCounter.text = Global.abreviateNum(Global.displayed_g) + " g's"
	pass
