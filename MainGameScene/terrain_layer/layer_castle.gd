extends TileMapLayerBase

@onready var pattterncnt := tile_set.get_patterns_count()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	pass # Replace with function body.


func _on_MapGenerator_GenerateTerrain() -> void:
	pass


func _on_MapGenerator_PlaceCastle(pos : Vector2i) -> void:
	clear()
	var pattern_count = tile_set.get_patterns_count()
	var p_idx : int = 0
	if pattern_count > 1:
		p_idx = randi_range(0,pattern_count)
	var pattern :TileMapPattern = tile_set.get_pattern(p_idx)
	var pattern_size = pattern.get_size()
	pos.y -= pattern_size.y
	set_pattern(pos, pattern)
	var mount = get_used_cells_by_id(10, Vector2i(0,5))
	if mount.size():
		var maplocal : Vector2 = map_to_local(mount[0])
		var mapglobal = to_global(maplocal)
		SignalBus.MapGeneratorPlaceCannon.emit(mapglobal)
	pass
