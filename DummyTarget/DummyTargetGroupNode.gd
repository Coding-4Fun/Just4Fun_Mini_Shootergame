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

	var tiles = Preloads.Map.get_used_cells_by_id(0)
	var tilecount = tiles.size()
	var randtile = ceil(rand_range(10, tiles.size()-1))
	if randtile < 10:
		print("Random Tile smaller as 10")
	var nxtTile = clamp(randtile, 10, tilecount-1)
	var tile_coord = tiles[nxtTile]
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


