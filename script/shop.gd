extends Node2D

@onready var background = $Background_Shop
@onready var shlimbombo = $chr_schlimbombo
@onready var grid = $Shop_Frame/ScrollContainer/GridContainer
@onready var gCounter = $GDisplay

@export var dudeCard : PackedScene

var price = 0.0

signal loaded
signal changeUI(name)

@export_file("*.tscn") var main_scene: String

func _physics_process(delta: float) -> void:
	background.position += ((get_global_mouse_position() / (.5) * delta) - background.position) - Vector2(150, 100)
	shlimbombo.position += ((get_global_mouse_position() / (.5 + 3) * delta) - shlimbombo.position) - Vector2(-450, -100)
	
func load_scene() -> void:
	await get_tree().create_timer(2.0).timeout
	loaded.emit()

func _ready() -> void:
	for dude in Global.data["upgrades"].keys():
		var dude_data = Global.data["upgrades"][dude]
		
		var card = dudeCard.instantiate()
		grid.add_child(card)
		
		card.setup(dude, dude_data)
		card.connect("buy", Callable(self, "_buy_pressed"))

func _on_exit() -> void:
	SceneManager.transition_to(main_scene)

func _buy_pressed(nm, amount, card):
	if Global.calculate_cost(nm, amount) <= Global.data["player"]["gAmount"]:
		Global._addGs(-(Global.calculate_cost(nm, amount)))
		Global.data["upgrades"][nm]["count"] += amount
		
		# $chr_schlimbombo.expression = "spr_ShopTalk"
		card.setup(nm, Global.data["upgrades"][nm])

func _process(delta: float) -> void:
	if Global.displayed_g < Global.data["player"]["gAmount"]:
		var difference = Global.data["player"]["gAmount"] - Global.displayed_g
		
		var step = max(100, difference * 10) * delta
		Global.displayed_g += step
			
		gCounter.text = Global.abreviateNum(Global.displayed_g) + " g's"
	elif Global.displayed_g > Global.data["player"]["gAmount"]:
		Global.displayed_g = Global.data["player"]["gAmount"]	
	else:
		gCounter.text = Global.abreviateNum(Global.displayed_g) + " g's"
	pass