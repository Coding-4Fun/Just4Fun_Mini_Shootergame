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
		"GameNetworkHostIPAdress": "127.0.0.1",
		"GameNetworkHostGamePort": "21277",
		"GameNetworkMaxPlayers": 2,
		"GameAudioMasterVolume": 100,
		"GameAudioSfxVolume": 100,
		"GameAudioMusicVolume": 100,
		"GameVideo": null,
		"GameKeyBinding": null
		}


func _ready() -> void:
	config_data = get_configdata()
	SignalBus.ConfigValueChanged.connect(_on_config_value_changed)


func get_configdata() -> Dictionary:
	var json = JSON.new()
	if not FileAccess.file_exists(GAMECONFIGFILE):
		save_gameconfig(true)

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
	elif CONFIGDATA_DEFAULT.has(valuetoget):
		config_data[valuetoget] = CONFIGDATA_DEFAULT[valuetoget]
	return v


func save_gameconfig (savedefault : bool = false):
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
	
	print("Signal Received: ConfigValueChange: ", [obj, value])
