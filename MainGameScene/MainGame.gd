extends Node2D

#onready var cannonLeft = Preloads.Cannon.instance()
#onready var cannonBarrelLeft = cannonLeft.get_node("Barrel")
#onready var cannonBarrelLeftMuzzle = cannonBarrelLeft.get_node("Muzzle")

#onready var cannonRight = cannon.instance()
#onready var cannonBarrelRight = cannonRight.get_node("Barrel")
#onready var cannonBarrelRightMuzzle = cannonBarrelRight.get_node("Muzzle")

var target


func _ready():
#	print("Main: _ready()")
	if !Preloads.UIMain.UIResetGame.is_connected(self._on_UI_ResetGame):
			var _cn = Preloads.UIMain.UIResetGame.connect(self._on_UI_ResetGame)

	Preloads.Map.generate_world_tilemap_base()


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
	Preloads.Map = find_child("TerrainMap")


func _on_MainGame_ready() -> void:
#	add_cannon_left()
	GSM.gameWin = -1
	SignalBus.CreateAndAddNewTarget.emit()
	pass


#func add_cannon_left(pos:Vector2 = Vector2.INF):
##	cannonLeft.position = TerrainLine.points[0]
##	cannonLeft.position.x = TerrainLine.castlewidth / 2
#	if pos == Vector2.INF:
#		var p = Preloads.Map.plattform[ceil(Preloads.Map.plattform.size()/2)]
#		cannonLeft.position = Preloads.Map.map_to_world(p)
##		cannonLeft.position.x = Chunk.castlewidth / 2
#		Preloads.PlayerLeft.add_child(cannonLeft)
#	else:
#		cannonLeft.position = pos
#	pass


func _on_UI_ResetGame() -> void:
#	print("Main: UIResetGame_Signal")
	GSM.gameWin = -1
	GSM.GameTimer.stop()
	GSM.GameTimerTimeElapsed = 0
	GSM.GameTimeTextLabel.text = "00:00"
	get_tree().call_group("Dummy", "queue_free")
	get_tree().call_group("Shoots", "queue_free")
	Preloads.Map.generate_world_tilemap_base()
	SignalBus.CreateAndAddNewTarget.emit()


#func update_trajectory():
#	pass


#func add_Castles():
#	pass
