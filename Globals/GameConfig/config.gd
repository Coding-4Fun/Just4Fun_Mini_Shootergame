extends Control

@export var config_data:Dictionary = {}
const GAMECONFIGFILE = "res://config.json"
const CONFIGDATA_DEFAULT_JSON:Dictionary = {
		"Player_name": "Unnamed",
		"Game": {
			"DummyTarget": {
				"TimerEnabled": false,
				"TimerCountdown": 6.0
			},
			"Condition": {
				"MaxGameTimeValue": 120,
				"MaxShotsEnabled": false,
				"MaxShotsValue": -0,
				"MinMaxScoreEnabled": false,
				"MinMaxScore": -1000,
				"MaxGameTimeEnabled": false,
				"MinMaxScoreValue": 1000
			},
		},
		"Network": {
			"HostIPAdress": "127.0.0.1",
			"HostGamePort": "21277",
			"MaxPlayers": 2
			},
		"Audio": {
			"MasterVolume": 100,
			"SfxVolume": 100,
			"MusicVolume": 100
			},
		"Video": {},
		"KeyBinding": {}
	}
const CONFIGDATA_DEFAULT:Dictionary = {
		"GamePlayerName": "Unnamed",
		"GameDummyTargetTimerEnabled": false,
		"GameDummyTargetTimerCountdown": 6.0,
		"GameConditionMaxGameTimeValue": 150,
		"GameConditionMaxShotsEnabled": true,
		"GameConditionMaxShotsValue": 10,
		"GameConditionMinMaxScoreEnabled": true,
		"GameConditionMinMaxScore": -100,
		"GameConditionMaxGameTimeEnabled": false,
		"GameConditionMinMaxScoreValue": 1000,
		"MapGeneratorSeed": 212197721011977,
		"MapGeneratorState": -1,
		"MapGeneratorLastState": -1,
		"GameNetworkHostIPAdress": "127.0.0.1",
		"GameNetworkHostGamePort": "21277",
		"GameNetworkMaxPlayers": 2,
		"GameAudioMasterVolume": 100,
		"GameAudioSfxVolume": 100,
		"GameAudioMusicVolume": 100,
		"GameVideo": null,
		"GameKeyBinding": null
		}

#signal ConfigValueChanged


func _ready() -> void:
	config_data = load_configdata_from_file()
	_check_DefaultConfig()
	
	SignalBus.ConfigValueChanged.connect(_on_config_value_changed)
	SignalBus.ConfigSaveDataToFile.connect(_on_ConfigSaveDataToFile)

	SignalBus.ConfigSaveDataToFile.emit()


func load_configdata_from_file() -> Dictionary:
	var json = JSON.new()
	if not FileAccess.file_exists(GAMECONFIGFILE):
		SignalBus.ConfigSaveDataToFile.emit(true)

	var file = FileAccess.open(GAMECONFIGFILE, FileAccess.READ)

	var content = file.get_as_text()
	var data = json.parse(content)
	file.close()
	if data == OK :
		if typeof(json.data) == TYPE_DICTIONARY:
			return json.data
		else:
			return CONFIGDATA_DEFAULT
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", content, " at line ", json.get_error_line())
	return(CONFIGDATA_DEFAULT)


func get_configdata_value(valuetoget: String, _vType : Variant.Type = Variant.Type.TYPE_NIL) -> Variant:
	var v : Variant = ""
	
	if valuetoget in config_data:
		v = config_data[valuetoget]
	else:
		return get_defaultvalue(valuetoget)
		
	return v


func _save_gameconfig (savedefault : bool = false):
	if savedefault:
		config_data = CONFIGDATA_DEFAULT
	var config = FileAccess.open(GAMECONFIGFILE, FileAccess.WRITE)
#	config.open(GAMECONFIGFILE, File.WRITE)
	var json = JSON.stringify(config_data, "\t")
	config.store_line(json)
	config.close()


#func _on_config_value_changed(obj: String= "", value : Variant = null, root: String = "Game", group: String= "") -> void:
func _on_config_value_changed(obj: String= "", value : Variant = null) -> void:
	# Check Object for Empty
	if obj.is_empty():
		return

	# Chack Value for NULL
	if value == null:
		return

	# save new Value to Config Dict / conf_File
	if obj in config_data:
		config_data[obj] = value
	else: #if not in memory, check if default value exists
		var def = get_defaultvalue(obj)
		if typeof(def) != Variant.Type.TYPE_NIL:
			config_data[obj] = value
	
	SignalBus.ConfigSaveDataToFile.emit()
	print("Signal Received: ConfigValueChange: ", [obj, value])


func _check_DefaultConfig() -> void:
	var keys = CONFIGDATA_DEFAULT.keys()
	for k in keys:
		if not k in config_data:
			config_data[k] = get_defaultvalue(k)
	pass


func get_defaultvalue(key : String) -> Variant:
	if key in CONFIGDATA_DEFAULT:
		return CONFIGDATA_DEFAULT.get(key)

	return null


func _on_ConfigSaveDataToFile(savedefault : bool = false) -> void:
	_save_gameconfig(savedefault)
