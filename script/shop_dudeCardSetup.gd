extends Control

func setup(name: String, data: Dictionary):
	$BOXFRAME/Name.text = name.capitalize()
	Global.fit_text($BOXFRAME/Name)
	
	var imgPath = "res://sprites/characters/upgrades/%s.png" % name
	if ResourceLoader.exists(imgPath):
		var tex = load(imgPath)
		$BOXFRAME/DudeTexture.texture = tex
	else:
		push_warning("missing %s texture" % name)
