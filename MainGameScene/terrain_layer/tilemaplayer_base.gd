extends TileMapLayer
class_name TileMapLayerBase

@onready var tile_size:Vector2i = tile_set.tile_size

@onready var screensize:Vector2 = get_viewport().get_visible_rect().size
@onready var midrange:float = screensize.y
@onready var displacement := ceili((midrange / tile_size.y) / 2) + randi_range(-10, 10)
@export var current_displacement = 0
@export var castlewidth : float = 200.0
@export var mod : int = floori(snapped(castlewidth, tile_size.x) / tile_size.x)
var plattform : Array[Vector2i] = []

enum block_types {
	AIR=-1,
	GRAS = 0,
	DIRT = 1,
	STONE = 2,
	BEDROCK = 3
}

# ToDo: Change to Vector2i(x,y)
var world_tiles_count : Vector2i = Vector2i()
var screenratio : float
var min_terrain_height : int
var max_terrain_height : int


## Calls from outside to initialize
func _start():
	print("Start() is called: %s" % name)
	pass


func _enter_tree() -> void:
	print("_enter_tree() is called: %s" % name)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.MapGeneratorGenerateTerrain.connect(_on_MapGenerator_GenerateTerrain)
	SignalBus.MapGeneratorPlaceCastle.connect(_on_MapGenerator_PlaceCastle)
	SignalBus.MapGeneratorPlaceCannon.connect(_on_MapGenerator_PlaceCannon)
	pass # Replace with function body.


func _on_MapGenerator_GenerateTerrain() -> void:
	pass


func _on_MapGenerator_PlaceCastle(_pos : Vector2i) -> void:
	pass


func _on_MapGenerator_PlaceCannon(_pattern : Vector2i) -> void:
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
