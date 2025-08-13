extends TextureRect

func reset_expression():
	var path = "res://sprites/characters/chr_schlimbombo/spr_ShopIdle.png"
	var tex = load(path)
	self.texture = tex

func update_expression_sprite():
	var path = "res://sprites/characters/chr_schlimbombo/%s.png" % expression
	if ResourceLoader.exists(path):
		var tex = load(path)
		self.texture = tex
		$schlimbombo.play("schlimbombochange")
	else:
		push_warning("expression sprite not found: %s" % path)
		

var expression: String = "neutral" :
	set(value):
		expression = value
		
