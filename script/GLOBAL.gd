extends Node

var displayed_g = 0.0

var data = {
	"player": {
		"gAmount" = 0.0,
		"gPerClick" = 1.0,
		"gPerSecond" = 0.0
	},
	"upgrades": {
		"gman": {
			"count": 0,
			"gps": 0.1,
			"cost": 10
		}
	}
}

func _savedatfile(data) -> void:
	var file := FileAccess.open("user://gdata.json", FileAccess.WRITE)
	if file == null:
		push_error("failed to open file for WRITING")
		return
	
	var json_string := JSON.stringify(data)
	file.store_string(json_string)

func _loaddatfile() -> Dictionary:
	var DEFAULT_data = {
	"player": {
		"gAmount" = 0.0,
		"gPerClick" = 1.0,
		"gPerSecond" = 0.0
	},
	"upgrades": {
		"gman": {
			"count": 0,
			"gps": 0.1,
			"cost": 10
		}
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
		return parsed
	else:
		push_error("corrupted or not dictionary. using default data")
		return DEFAULT_data
	

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

func _process(delta: float) -> void:
	_addGs(data["player"]["gPerSecond"] * delta)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_savedatfile(data)

func _ready() -> void:
	data = _loaddatfile()
	
