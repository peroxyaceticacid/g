extends Control

signal buy(nm : String, amount : int)

func setup(name: String, data: Dictionary):
	$BOXFRAME/Name.text = name.capitalize()
	Global.fit_text($BOXFRAME/Name)
	# $BOXFRAME/amount.text = "u got " + str(Global.data["upgrades"][name]["count"])
	$BOXFRAME/amount.text = "u got " + str(Global.abreviateNum(int(data["count"])))
	$BOXFRAME/cost.text = str(Global.abreviateNum(Global.calculate_cost(name, 1))) + "gs"
	
	var imgPath = "res://sprites/characters/upgrades/%s.png" % name
	if ResourceLoader.exists(imgPath):
		var tex = load(imgPath)
		$BOXFRAME/DudeTexture.texture = tex
	else:
		push_warning("missing %s texture" % name)
	
	$"BOXFRAME/1".pressed.connect(Callable(self, "on_buy").bind(1, name))
	
func refresh(nm):
	$BOXFRAME/Name.text = name.capitalize()
	Global.fit_text($BOXFRAME/Name)
	# $BOXFRAME/amount.text = "u got " + str(Global.data["upgrades"][name]["count"])
	$BOXFRAME/amount.text = "u got " + str(Global.abreviateNum(int(Global.data["upgrades"][nm]["count"])))
	$BOXFRAME/cost.text = str(Global.abreviateNum(Global.calculate_cost(name, 1))) + "gs"

func on_buy(am, nm):
	emit_signal("buy", nm, am, self)
