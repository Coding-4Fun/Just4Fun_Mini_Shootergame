extends Node2D

func _ready():
	#	CreateAndAddNewTarget _on_Create_Add_NewTarget
	if !SignalBus.is_connected("CreateAndAddNewTarget", self._on_Create_Add_NewTarget):
###		assert(SignalBus.connect("CreateAndAddNewTarget", self, "_on_Create_Add_NewTarget")==OK)
		if SignalBus.connect("CreateAndAddNewTarget", self._on_Create_Add_NewTarget) != OK:
			print("Error - DummyTargetGroupNode.gd: connect signal CreateAndAddNewTarget")

	if !SignalBus.is_connected("TargetHitted", self._on_Target_Hited):
###		assert(SignalBus.connect("TargetHitted", self, "_on_Target_Hited")==OK)
		if SignalBus.connect("TargetHitted", self._on_Target_Hited) != OK:
			print("Error - DummyTargetGroupNode.gd: connect signal TargetHitted")

	pass


func _on_Create_Add_NewTarget() -> void:
	var target : Node2D

	randomize()

	var tilecount = Preloads.Map.world_tiles_x
	var randtile = ceil(randi_range(Preloads.Map.mod + 10, tilecount-1))

	var tile_coord : Vector2i

	for y in range(0, Preloads.Map.world_tiles_y-1):
		var tid = Preloads.Map.get_cell_source_id(0,Vector2i(randtile, y))
		if tid == 0:
			tile_coord = Vector2i(randtile, y)
#			print("Tile: %s" % str(tile_coord))
			break

	var posi:Vector2i = Preloads.Map.map_to_local(tile_coord)
	# posi.x += 8
	posi.y -= floori(Preloads.Map.tile_set.tile_size.y / 2.0)

	target = Preloads.DummyTarget.instantiate()
	target.position = posi
	target.score += int(randtile)

	add_child(target)
	pass


func _on_Target_Hited(score : int) -> void:
	SignalBus.emit_signal("UIScoreChange", score)
	SignalBus.emit_signal("CreateAndAddNewTarget")


