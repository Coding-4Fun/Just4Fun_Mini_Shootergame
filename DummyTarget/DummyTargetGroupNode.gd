extends Node2D

var target

func _ready():
	#	CreateAndAddNewTarget _on_Create_Add_NewTarget
	if !SignalBus.is_connected("CreateAndAddNewTarget", self, "_on_Create_Add_NewTarget"):
		assert(SignalBus.connect("CreateAndAddNewTarget", self, "_on_Create_Add_NewTarget")==OK)
	
	if !SignalBus.is_connected("TargetHitted", self, "_on_Target_Hited"):
		assert(SignalBus.connect("TargetHitted", self, "_on_Target_Hited")==OK)

	pass


func _on_Create_Add_NewTarget() -> void:
	randomize()

	var tilecount = Preloads.Map.world_tiles_x
	var randtile = ceil(rand_range(Preloads.Map.mod + 10, tilecount-1))

	var tile_coord
	
	for y in range(0, Preloads.Map.world_tiles_y-1):
		var tid = Preloads.Map.get_cell(randtile, y)
		if tid == 0:
			tile_coord = Vector2(randtile, y)
#			print("Tile: %s" % str(tile_coord))
			break

	var posi = Preloads.Map.map_to_world(tile_coord)
	posi.x += 8
	
	target = Preloads.DummyTarget.instance()
	target.position = posi
	target.score += int(randtile)

	add_child(target)
	pass


func _on_Target_Hited(score : int) -> void:
	SignalBus.emit_signal("UIScoreChange", score)
	SignalBus.emit_signal("CreateAndAddNewTarget")


