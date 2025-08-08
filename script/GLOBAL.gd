extends Node

var displayed_g = 0.0

var data = {
	"gAmount": 0.0,
	"gPerClick": 1.0,
	"gPerSecond": 0.0
}

func _savedatfile(data) -> void:
	var file := FileAccess.open("user://gdata.dat", FileAccess.WRITE)
	if file == null:
		push_error("failed to open file for WRITING")
		return
	
	
	for i in data:
		file.store_line("%s=%s" % [i, data[i]])

func _loaddatfile() -> Dictionary:
	var result: Dictionary = {}
	
	if not FileAccess.file_exists("user://gdata.dat"):
		push_warning("Save file not there vro")
		return result
	
	var file := FileAccess.open("user://gdata.dat", FileAccess.READ)
	if file == null:
		push_error("failed to open file for READING")
		return result
	
	while not file.eof_reached():
		var line := file.get_line().strip_edges()
		if line == "" or line.begins_with("#"):
			continue
		
		var parts := line.split("=")
		if parts.size() == 2:
			var key := parts[0]
			var value = parts[1]
			
			if value.is_valid_int():
				value = int(value)
			elif value.is_valid_float():
				value = float(value)
			
			result[key] = value
	
	return result

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
	data["gAmount"] += amount

func _process(delta: float) -> void:
	_addGs(data["gPerSecond"] * delta)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_savedatfile(data)

func _ready() -> void:
	data = _loaddatfile()
	
