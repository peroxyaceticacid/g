extends Node

var displayed_g = 0.0

var data = {
	"player": {
		"gAmount" = 0.0,
		"gPerClick" = 1.0,
	},
	"upgrades": {
		"gman": {
			"count": 0,
		},
		"tabby": {
			"count": 0,
		},
		"golden": {
			"count": 0,
		},
		"gabe": {
			"count": 0,
		},
		"glibble": {
			"count": 0,
		},
		"babru": {
			"count": 0,
		},
		"mugdude": {
			"count": 0,
		},
		"evil mug": {
			"count": 0,
		},
	}
}

var upgrade_stats = {
	"gman": {
		"base_cost": 10,
		"gps": 0.1
	},
	"tabby": {
		"base_cost": 100,
		"gps": 1.0
	},
	"golden": {
		"base_cost": 1000,
		"gps": 7.0
	},
	"gabe": {
		"base_cost": 2600,
		"gps": 15.0
	},
	"glibble": {
		"base_cost": 3500,
		"gps": 50.0
	},
	"babru": {
		"base_cost": 8230,
		"gps": 80.0
	},
	"mugdude": {
		"base_cost": 15000,
		"gps": 111.0
	},
	"evil mug": {
		"base_cost": 66666,
		"gps": 6666.0
	},
}

func total_gps() -> float:
	var total = 0.0
	for dude in data["upgrades"].keys():
		var count = data["upgrades"][dude]["count"]
		var gps = upgrade_stats[dude]["gps"]
		total += count * gps
		
	return total
	
func calculate_cost(dude : String, amount : int) -> int:
	var count = data["upgrades"][dude]["count"]
	var base_cost = upgrade_stats[dude]["base_cost"]
	return int(floor(base_cost * pow(1.15, (count + (amount- 1)))))

func _savedatfile(data2save) -> void:
	var file := FileAccess.open("user://gdata.json", FileAccess.WRITE)
	if file == null:
		push_error("failed to open file for WRITING")
		return
	
	var json_string := JSON.stringify(data2save)
	file.store_string(json_string)

func _loaddatfile() -> Dictionary:
	var loaded_data: Dictionary
	
	var DEFAULT_data = {
	"player": {
		"gAmount" = 0.0,
		"gPerClick" = 1.0,
	},
	"upgrades": {
		"gman": {
			"count": 0,
		},
		"tabby": {
			"count": 0,
		},
		"golden": {
			"count": 0,
		},
		"gabe": {
			"count": 0,
		},
		"glibble": {
			"count": 0,
		},
		"babru": {
			"count": 0,
		},
		"mugdude": {
			"count": 0,
		},
		"evil mug": {
			"count": 0,
		},
	}
}
	
	if not FileAccess.file_exists("user://gdata.json"):
		push_warning("Save file not there vro. im using base data instead.")
		return DEFAULT_data
	
	var file := FileAccess.open("user://gdata.json", FileAccess.READ)
	if file == null:
		push_error("failed to open file for READING. using default data")
		return DEFAULT_data
	
	var content := file.get_as_text()
	var parsed = JSON.parse_string(content)
	
	if typeof(parsed) == TYPE_DICTIONARY:
		loaded_data = parsed
	else:
		push_error("corrupted or not dictionary. using default data")
		return DEFAULT_data
		
	var merged_data = DEFAULT_data.duplicate(true)
	
	for section in DEFAULT_data.keys():
		if loaded_data.has(section):
			for key in DEFAULT_data[section]:
				if loaded_data[section].has(key):
					merged_data[section][key] = loaded_data[section][key]
	return merged_data
	

func commaNum(n: int) -> String:
	var s = str(n)
	var result : String
	while s.length() > 3:
		result = "," + s.substr(s.length() - 3, 3) + result
		s = s.substr(0, s.length() - 3)
	result = s + result
	return result

func abreviateNum(n : float) -> String:
	if n >= 1000.0 and n < 1000000.0:
		return commaNum(int(n))
	elif n >= 1000000.0 and n < 1000000000.0:
		return str(snapped(n / 1000000.0, .1)) + "M"
	elif n >= 1000000000.0 and n < 1000000000000.0:
		return str(snapped(n / 1000000000.0, .1)) + "B"
	elif n >= 1000000000000.0 and n < 1000000000000000.0:
		return str(snapped(n / 1000000000000.0, .1)) + "T"
	elif n >= 1000000000000000.0:
		return str(snapped(n / 1000000000000000.0, .1)) + "Qd"
	else:
		return str(int(n))
		
func _addGs(amount):
	data["player"]["gAmount"] += amount
	
func fit_text(label: Label):
	var font_size = label.get_theme_font_size("font_size")
	var font = label.get_theme_font("font")
	var max_width = label.size.x

	while font.get_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x > max_width and font_size > 8:
		font_size -= 1

	label.add_theme_font_size_override("font_size", font_size)

func _process(delta: float) -> void:
	_addGs(total_gps() * delta)
	
func get_random_texture() -> Texture2D:
	var folder_path = "res://sprites/characters/upgrades/"
	var dir = DirAccess.open(folder_path)

	if dir == null:
		push_error("Could not open upgrade texture folder!")
		return null

	var files = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".png"):
			files.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	if files.is_empty():
		push_warning("No textures found in: %s" % folder_path)
		return null

	var random_file = files[randi() % files.size()]
	var full_path = folder_path + random_file
	return load(full_path) as Texture2D


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_savedatfile(data)

func _ready() -> void:
	randomize()
	data = _loaddatfile()
	
