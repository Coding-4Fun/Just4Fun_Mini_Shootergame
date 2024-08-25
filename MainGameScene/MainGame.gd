extends Node2D


var target


func _ready():
	#ToDo: Change to global SignalBus
	if !SignalBus.UIResetGame.is_connected(self._on_UI_ResetGame):
			var _cn = SignalBus.UIResetGame.connect(self._on_UI_ResetGame)

	# ToDo change to global Signal
	SignalBus.MapGenerateWorldTileMap.emit()


func _enter_tree() -> void:
	# Player Node's
	Preloads.PlayerRootNode = get_node("Players")
	Preloads.PlayerLeft = find_child("Player1")
	Preloads.PlayerRight = find_child("Player2")
	Preloads.PlayerShots = find_child("Shots")

	## UI
	Preloads.UIMain = find_child("InGameUI")

	## Dummy Gruppen Node
	Preloads.DummyTargetGroup = find_child("DummyTargets")

	## TileMap
	# ToDo: Using TileMapLayer TerrainLayer
	Preloads.Map = find_child("LayerTerrain")

	pass


func _on_MainGame_ready() -> void:
	GSM.gameWin = -1
	SignalBus.CreateAndAddNewTarget.emit()


func _on_UI_ResetGame() -> void:
	GSM.gameWin = -1
	GSM.GameTimer.stop()
	GSM.GameTimerTimeElapsed = 0
	GSM.GameTimeTextLabel.text = "00:00"
	get_tree().call_group("Dummy", "queue_free")
	get_tree().call_group("Shoots", "queue_free")
	#ToDo: Change to Signal
	#Preloads.Map.generate_world_tilemap_base()
	SignalBus.MapGenerateWorldTileMap.emit()
	SignalBus.CreateAndAddNewTarget.emit()
