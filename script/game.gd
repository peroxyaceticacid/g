extends Node2D

# ANIMATIONS
@onready var ButtonAnimationIDLEPlayer = $Animations/anim_GButtonIdle
@onready var ButtonAnimationCLICKPlayer = $Animations/anim_GButtonClick

# PARTICLES
@onready var G_EXPLODE = $Particles/particle_GExplode

# PRELOAD SCENES
var particlescene = preload("res://scenes/particles.tscn")

func _ready() -> void:
	ButtonAnimationIDLEPlayer.play("anim_GBIdle")
	pass

func _onclick():
	if ButtonAnimationCLICKPlayer.is_playing() == true:
		ButtonAnimationCLICKPlayer.stop()
	ButtonAnimationCLICKPlayer.play("anim_GBClick")
	
	var explosioneffect = particlescene.instantiate()
	
	
	print("test")

func _process(delta: float) -> void:
	pass
