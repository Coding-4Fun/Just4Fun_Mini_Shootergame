extends TileMapLayer
class_name TileMapLayerBase

var tile_size:Vector2 = Vector2(16.0,16.0)

@onready var screensize:Vector2 = get_viewport().get_visible_rect().size
@onready var midrange:float = screensize.y
@onready var displacement := ceili((midrange / tile_size.y) / 2) + randi_range(-10, 10)
@export var mod : int = floori(snapped(castlewidth, tile_size.x) / tile_size.x)
@export var current_displacement = 0
@export var castlewidth : float = 200.0
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
var world_tiles_x : int
var world_tiles_y : int
var screenratio : float
var min_terrain_height : int
var max_terrain_height : int

## Calls from outside to initialize
func _start():
	print("Start() is called: %s" % name)
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
