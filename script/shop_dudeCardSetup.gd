extends Control

signal buy(nm : String, amount : int)

func setup(name: String, data: Dictionary):
	$BOXFRAME/Name.text = name.capitalize()
	Global.fit_text($BOXFRAME/Name)
	
	var imgPath = "res://sprites/characters/upgrades/%s.png" % name
	if ResourceLoader.exists(imgPath):
		var tex = load(imgPath)
		$BOXFRAME/DudeTexture.texture = tex
	else:
		push_warning("missing %s texture" % name)
	
	$"BOXFRAME/1".pressed.connect(Callable(self, "on_buy").bind(1, name))
	$"BOXFRAME/5".pressed.connect(Callable(self, "on_buy").bind(5, name))
	$"BOXFRAME/10".pressed.connect(Callable(self, "on_buy").bind(10, name))

func on_buy(am, nm):
	emit_signal("buy", nm, am)