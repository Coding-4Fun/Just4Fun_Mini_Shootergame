extends TileMapLayerBase

@onready var pattterncnt := tile_set.get_patterns_count()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.MapGenerateWorldTileMap.connect(_on_MapGeneratorWorldTileMap)
	pass # Replace with function body.


func _on_MapGeneratorWorldTileMap() -> void:
	clear()
