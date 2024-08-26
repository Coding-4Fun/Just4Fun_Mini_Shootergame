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
	print("CastleLayer_Place signal")
	var pattern_count = tile_set.get_patterns_count()
	var pattern :TileMapPattern = tile_set.get_pattern(0)
	var pattern_size = pattern.get_size()
	pos.y -= pattern_size.y
	set_pattern(pos, pattern)	
	pass
