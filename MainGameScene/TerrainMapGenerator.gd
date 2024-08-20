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
	var chgdispl = 0
	for x in world_tiles_x:
		if x <= mod:
			current_displacement = displacement
		for y in world_tiles_y:

			# BasePlattform
			if x <= mod and y == current_displacement:
				set_cell(0, Vector2i(x,y), 6, Vector2i(0, 0))
				plattform.append(Vector2i(x, y))
				chgdispl = 0
				continue
			# Graslinie
			elif y == current_displacement:
				chgdispl = chgdispl *-1
				if chgdispl == 0:
					print("X=%d / Y=%d -- current == 0: %d" % [x, y, chgdispl])
					set_cell(0, Vector2i(x,y), 8, Vector2i(0, 0))
				elif chgdispl < 0:
					print("X=%d / Y=%d -- current < 0: %d" % [x, y, chgdispl])
					set_cell(0, Vector2i(x,y-1), 8, Vector2i(1, 0))
				elif chgdispl > 0:
					print("X=%d / Y=%d -- current > 0: %d" % [x, y, chgdispl])
					set_cell(0, Vector2i(x,y), 8, Vector2i(2, 0))

			# Dirt für Graslinie + 2
			elif y > current_displacement and y <= current_displacement+2:
				set_cell(0, Vector2i(x,y-1 if chgdispl < 0 else y), 1, Vector2i(0, 0))

			# Unterhalb der Dirtlinie, zufällige Tiles
			if y > current_displacement+2 and y < world_tiles_y-2:
				var rdm = randi_range(1,5)
				set_cell(0, Vector2i(x,y-1 if chgdispl < 0 else y), rdm, Vector2i(0, 0))
			# Abschluss Linie , y - 2
			elif y >= world_tiles_y-2:
				set_cell(0, Vector2i(x,y), 7, Vector2i(0, 0))
			# End Y Loop
		var lastchg = chgdispl
		chgdispl = sign(randi_range(-5, 5))		# -1 || 0 || 1
		if lastchg != 0 and lastchg !=chgdispl:
			chgdispl = 0
		var change_displacement = current_displacement + chgdispl
		current_displacement = change_displacement
