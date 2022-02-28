extends Node2D


signal CannonReset


onready var cannonLeft = Preloads.Cannon.instance()
onready var cannonBarrelLeft = cannonLeft.get_node("Barrel")
onready var cannonBarrelLeftMuzzle = cannonBarrelLeft.get_node("Muzzle")

#onready var cannonRight = cannon.instance()
#onready var cannonBarrelRight = cannonRight.get_node("Barrel")
#onready var cannonBarrelRightMuzzle = cannonBarrelRight.get_node("Muzzle")




var target


func _ready():

#	if !is_connected("UIScoreChange", Preloads.UIMain, "_on_UIScore_Change"):
#		var _res = connect("UIScoreChange", Preloads.UIMain, "_on_UIScore_Change")

#	Preloads.UIMain.connect("UIResetGame", self, "_on_UI_ResetGame")
#	Preloads.UIMain.connect("UIdummyTargetTimerChange", Config, "_on_dummytarget_TimerChange")

#	var tmp = connect("CannonReset", Preloads.cannonLeft, "_reset_CannonPower")
#	if (tmp) != OK:
#		print("Connect MainGame::_ready() -> Connect to CannonReset Fehlgeschlagen: %s" % tmp)

#	Preloads.Map.generate_world_tilemap_base()
#	$Chunk.generate_world_block_base()
	pass


func _on_MainGame_ready() -> void:
#	add_cannon_left()
#	add_DummyTarget()
	pass


func add_cannon_left(pos:Vector2 = Vector2.INF):
#	cannonLeft.position = TerrainLine.points[0]
#	cannonLeft.position.x = TerrainLine.castlewidth / 2
	if pos == Vector2.INF:
		var p = Preloads.Map.plattform[ceil(Preloads.Map.plattform.size()/2)]
		cannonLeft.position = Preloads.Map.map_to_world(p)
#		cannonLeft.position.x = Chunk.castlewidth / 2
		Preloads.PlayerLeft.add_child(cannonLeft)
	else:
		cannonLeft.position = pos


func add_DummyTarget():
	randomize()

#	var rand = ceil(rand_range(Preloads.Map.mod, Preloads.Map.world_tiles_x))
	var tiles = Preloads.Map.get_used_cells_by_id(0)

	var randtile = ceil(rand_range(0, tiles.size()-1))

	target = Preloads.DummyTarget.instance()
	var tile_coord = tiles[ceil(randtile)]
	var posi = Preloads.Map.map_to_world(tile_coord)
	target.position = posi
	target.score += int(randtile)
#	target.get_transform().scaled(Vector2(1,1))
	target.autoDespawn = Config.config_data["Game"]["DummyTarget"]["TimerEnabled"]

	if !target.is_connected("Hit", self, "_on_Dummy_Hited"):
		target.connect("Hit", self, "_on_Dummy_Hited")

	call_deferred("add_child", target)
	call_deferred("add_child", target)


func _on_Dummy_Hited(score : int) -> void:
	emit_signal("UIScoreChange", score)
#	add_DummyTarget()


func _on_UI_ResetGame() -> void:
#	print("Main: UIResetGame_Signal")
#	ToDo:
#	Vor dem generieren bei Reset
#	Erst die alten Blocks entfernen
	get_tree().call_group("Dummy", "queue_free")
	get_tree().call_group("Shoots", "queue_free")
	yield(get_tree(), "idle_frame")
#	emit_signal("CannonReset")
#	add_DummyTarget()

#	add_cannon_left(pos)

#	tank.can_shoot = true
#	line.hide()


#func update_trajectory():
#	line.clear_points()
#	var v = barrel.global_transform.x * tank.bullet_speed
#	var p = muzzle.global_position
#	for i in num_points:
#		line.add_point(p)
#		v.y += tank.gravity * dt
#		p += v * dt
#		if p.y > $Ground.position.y - 25:
#			break
#	pass


#func add_Castles():
#	castleleft.position = TerrainLine.points[0]
#	castleleft.modulate = Color.red
#
#	castleright.position = TerrainLine.points[TerrainLine.points.size()-2]
#	castleright.modulate = Color.green
#
#	add_child(castleleft)
#	add_child(castleright)
#	pass
