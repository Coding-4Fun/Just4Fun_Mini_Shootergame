extends TileMap

var tile_size:Vector2 = Vector2(16,16)

onready var screensize:Vector2 = get_viewport().get_visible_rect().size
onready var midrange:int = screensize.y
onready var displacement = ceil((midrange / tile_size.y) / 2)
export var current_displacement = 0
export var castlewidth = 175

enum block_types {
	AIR=-1,
	GRAS = 0,
	DIRT = 1,
	STONE = 2,
	BEDROCK = 3
}

var world_tiles_x:int
var screenratio:float
var world_tiles_y:int
var min_terrain_height:int
var max_terrain_height:int

export (float) var mod = stepify(castlewidth, tile_size.x) / tile_size.x

func _ready() -> void:
	world_tiles_x = screensize.x / tile_size.x
	screenratio = screensize.x / screensize.y
# warning-ignore:narrowing_conversion
	world_tiles_y = ceil(world_tiles_x / screenratio)
	min_terrain_height = world_tiles_y - mod
	max_terrain_height = mod


func generate_world_tilemap_base() -> void:
	for x in range(world_tiles_x):
		for y in range(world_tiles_y):
			if y == displacement:
				set_cellv(Vector2(x,y), 0)
			if y > displacement:
				set_cellv(Vector2(x,y), 1)
			pass
