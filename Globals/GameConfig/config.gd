extends Control

export var config_data:Dictionary = {}
const GAMECONFIGFILE = "res://config.json"
const CONFIGDATA_DEFAULT:Dictionary = {
		"Player_name": "Unnamed",
		"Game": {
			"DummyTarget": {
				"TimerEnabled": true,
				"TimerCountdown": 6
			},
			"Condition": {
				"MaxShotsEnabled": false,
				"MaxShotsValue": -0,
				"MinMaxScoreEnabled": false,
				"MinMaxScore": -1000
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

	# lobby.connect("playername_changed", self, "_on_playername_change")
	# lobby.connect("hostip_changed", self, "_on_hostip_change")
	# lobby.connect("hostport_changed", self, "_on_hostport_change")
	# lobby.connect("maxplayers_changed", self, "_on_maxplayer_change")


func get_configdata() -> Dictionary:
	var file = File.new()
	if not file.file_exists(GAMECONFIGFILE):
		config_data = CONFIGDATA_DEFAULT
		save_gameconfig()
	file.open(GAMECONFIGFILE, File.READ)
	var content = file.get_as_text()
	var data = JSON.parse(content)
	file.close()
	if data.error == OK :
		if typeof(data.result) == TYPE_DICTIONARY:
			return data.result
		else:
			return CONFIGDATA_DEFAULT
	return(CONFIGDATA_DEFAULT)


func save_gameconfig ():
	var config = File.new()
	config.open(GAMECONFIGFILE, File.WRITE)
	config.store_line(to_json(config_data))
	config.close()


func _on_playername_change(newname:String) -> void:
	if not newname.empty():
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
