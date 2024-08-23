extends Node2D

## TileMapLayer
@export var MapLayer : Array[TileMapLayer] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Terrain / Map
	SignalBus.MapSetCastle.connect(_on_MapSetCastle_signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	SignalBus.MapGenerateWorldTileMap.connect(_on_MapGenerateWorldTileMap_signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	
	_get_TileMapLayer()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_MapGenerateWorldTileMap_signal() -> void:
	pass

## Set the Player Castle in Castle Layer
func _on_MapSetCastle_signal() -> void:
	pass


func _get_TileMapLayer() -> void:
	#for layer in get_children():
	var layer = get_children()
	for l in layer:
		if l is TileMapLayer:
			MapLayer.append(l)
			if l.has_method("_start"):
				l.call_deferred("_start")
	pass
