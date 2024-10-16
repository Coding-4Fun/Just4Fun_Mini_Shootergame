extends Node2D

func _ready():
	#	CreateAndAddNewTarget _on_Create_Add_NewTarget
	if !SignalBus.CreateAndAddNewTarget.is_connected(self._on_Create_Add_NewTarget):
		if SignalBus.CreateAndAddNewTarget.connect(self._on_Create_Add_NewTarget) != OK:
			print("Error - DummyTargetGroupNode.gd: connect signal CreateAndAddNewTarget")

	if !SignalBus.TargetHitted.is_connected(self._on_Target_Hited):
		if SignalBus.TargetHitted.connect(self._on_Target_Hited) != OK:
			print("Error - DummyTargetGroupNode.gd: connect signal TargetHitted")

	pass


func _on_Create_Add_NewTarget() -> void:
	var target : Node2D

	#randomize()
	print("DummyTarget Seed: %s" % str(Preloads.rng.seed))

	var tilecount = Preloads.TerrainLayer.world_tiles_count.x
	var randtile = ceil(Preloads.rng.randi_range(Preloads.TerrainLayer.mod + 10, tilecount-1))
	#var randtile = ceil(randi_range(Preloads.TerrainLayer.mod + 10, tilecount-1))

	var tile_coord : Vector2i

	for y in range(0, Preloads.TerrainLayer.world_tiles_count.y-1):
		var tid = Preloads.TerrainLayer.get_cell_source_id(Vector2i(randtile, y))
		if tid == 8:
			tile_coord = Vector2i(randtile, y)
#			print("Tile: %s" % str(tile_coord))
			break

	var posi:Vector2i = Preloads.TerrainLayer.map_to_local(tile_coord)
	# posi.x += 8
	#posi.y += floori(Preloads.TerrainLayer.tile_set.tile_size.y) # / 4.0)

	target = Preloads.DummyTarget.instantiate()
	target.position = posi
	target.score += int(randtile)

	add_child(target)
	pass


func _on_Target_Hited(score : int) -> void:
	if score != 0:
		SignalBus.UIScoreChange.emit(score)
		SignalBus.CreateAndAddNewTarget.emit()
