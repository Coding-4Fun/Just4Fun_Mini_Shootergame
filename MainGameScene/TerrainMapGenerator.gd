extends TileMap

var tile_size:Vector2 = Vector2i(16,16) #.ceil()



@onready var screensize:Vector2 = get_viewport().get_visible_rect().size
@onready var midrange:float = screensize.y
@onready var displacement := ceili((midrange / tile_size.y) / 2)
@export var current_displacement = 0
@export var castlewidth = 175
var plattform := [Vector2i()]

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

@export var mod : int = floori(snappedf(castlewidth, tile_size.x) / tile_size.x)

func _ready() -> void:
	world_tiles_x = int(screensize.ceil().x / tile_size.ceil().x)
	screenratio = ceil(screensize.x) / ceil(screensize.y)
# warning-ignore:narrowing_conversion
	world_tiles_y = ceil(world_tiles_x / screenratio)
	min_terrain_height = world_tiles_y - mod
	max_terrain_height = mod


func Reset_TileMap() -> void:
	## Woraround um die Burg zu behalten
	var Castle = get_used_cells_by_id(0, 6)
	clear()
	for i in Castle.size():
		set_cell(0, Castle[i],6, Vector2i(0, 0))
	pass


func generate_world_tilemap_base() -> void:
	Reset_TileMap()
	randomize()
	current_displacement = displacement
	for x in world_tiles_x:
		if x <= mod:
			current_displacement = displacement
		for y in world_tiles_y:
			# update_dirty_quadrants()
			# BasePlattform
			if x <= mod and y == current_displacement:
				set_cell(0, Vector2i(x,y), 6, Vector2i(0, 0))
				plattform.append(Vector2i(x, y))
				continue
			# Graslinie
			elif y == current_displacement:
				set_cell(0, Vector2i(x,y), 0, Vector2i(0, 0))
			# Unterhalb der Graslinie
			if y > current_displacement and y < world_tiles_y-2:
				var rdm = randi_range(1,5)
				rdm = ceili(rdm)
#				rdm = int(rdm)
				set_cell(0, Vector2i(x,y), rdm, Vector2i(0, 0))
			elif y >= world_tiles_y-2:
				set_cell(0, Vector2i(x,y), 7, Vector2i(0, 0))
			# End Y Loop



		var change_displacement = current_displacement + sign(randi_range(-5, 5))# pow(-1.0, randi() % 2)
		current_displacement = change_displacement
