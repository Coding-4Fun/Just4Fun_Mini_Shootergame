extends Control

@export var config_data:Dictionary = {}
const GAMECONFIGFILE = "res://config.json"
const CONFIGDATA_DEFAULT:Dictionary = {
		"Player_name": "Unnamed",
		"Game": {
			"DummyTarget": {
				"TimerEnabled": false,
				"TimerCountdown": 6
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

#signal playername_changed (string)
# signal dummyTargetTimerChange
 # (string)
#signal hostip_changed(string)
#signal hostport_changed(string)
#signal maxplayers_changed(string)

# onready var lobby = get_node("/root/Lobby")

func _ready() -> void:
	config_data = get_configdata()


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


func save_gameconfig (savedefault : bool = false):
	if savedefault:
		config_data = CONFIGDATA_DEFAULT
	var config = FileAccess.open(GAMECONFIGFILE, FileAccess.WRITE)
#	config.open(GAMECONFIGFILE, File.WRITE)
	var json = JSON.stringify(config_data, "\t")
	config.store_line(json)
	config.close()


func _on_playername_change(newname:String) -> void:
	if not newname.is_empty():
		config_data["Player_name"] = newname
		save_gameconfig()
	else:
		print("Bitte name eingeben")


func _on_dummytarget_TimerChange(newValue:bool) -> void:
	Config.config_data["Game"]["DummyTarget"]["TimerEnabled"] = newValue


# func _on_hostip_change(newhostip:String) -> void:
	# if not newhostip.empty():
		# Config.config_data["Network"]["HostIPAdress"] = newhostip
		# Config.save_gameconfig()
	# else:
		# print("Bitte IP Adresse eingeben")


# func _on_hostport_change(newhostport: int) -> void:
	# if newhostport > 0:
		# Config.config_data["Network"]["HostGamePort"] = newhostport
		# Config.save_gameconfig()
	# else:
		# print("Bitte Port eingeben")


# func _on_maxplayer_change(newmaxplayers:int) -> void:
	# if newmaxplayers > 0:
		# Config.config_data["Network"]["MaxPlayers"] = newmaxplayers
		# Config.save_gameconfig()
	# else:
		# print("Bitte Maximale anzahl Spieler eingeben")
