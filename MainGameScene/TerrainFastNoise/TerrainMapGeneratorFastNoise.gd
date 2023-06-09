extends TileMap

class TileDictionary:
#	public static Vector2i WATER = new(0, 0);
#    public static Vector2i SAND = new(2, 0);
#    public static Vector2i GRASS = new(0, 2);
#    public static Vector2i GRASSIER_GRASS = new(2, 4);
#    public static Vector2i ROCK = new(2, 2);
#    public static Vector2i ROCKIER_ROCK = new(0, 4);
	
	const GRASS := Vector2i(0, 0)
	const DIRT := Vector2i(0, 0)
	const COBBLE := Vector2i(0, 0)
	const MOSSYCOBBLE := Vector2i(0, 0)
	const COAL := Vector2i(0, 0)
	const CLAY := Vector2i(0, 0)
	const STONEBRICK := Vector2i(0, 0)
	const REDBRICK := Vector2i(0, 0)



@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
@onready var screensize:Vector2 = get_viewport().get_visible_rect().size
@onready var midrange:float = screensize.y		# 900px
@onready var displacement := ceili((midrange / tile_size.y) / 2)	# ((900/16)/2) = 28,125 ~= 28
@export var current_displacement : int = 0
@export var castlewidth = 175
@export var mod : int = 0	# ((175,16)=176/16)=11


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

var tile_size:Vector2 = Vector2i(16,16) #.ceil()
var plattform := [Vector2i()]


enum TileDictionaryEnum {
	AIR=-1,GRAS,DIRT,COBBLE,MOSS_COBBLE,COAL,CLAY,STONEBRICK,REDBRICK
}


const image_size := Vector2i(512, 512)
const image_format := Image.FORMAT_RGB8
const noise_types: Array = [
	FastNoiseLite.TYPE_SIMPLEX,
	FastNoiseLite.TYPE_SIMPLEX_SMOOTH,
	FastNoiseLite.TYPE_CELLULAR,
	FastNoiseLite.TYPE_PERLIN,
	FastNoiseLite.TYPE_VALUE,
	FastNoiseLite.TYPE_VALUE_CUBIC
]

@onready var noise :FastNoiseLite = FastNoiseLite.new()
#var img := Image.create(image_size.x, image_size.y, false, image_format)


# Called when the node enters the scene tree for the first time.
func _ready():
	mod = floori(snappedf(castlewidth, tile_size.x) / tile_size.x)
	rng.randomize()

	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.fractal_octaves = 1
	noise.fractal_gain = 1

	world_tiles_x = int(screensize.ceil().x / tile_size.ceil().x)
	screenratio = ceil(screensize.x) / ceil(screensize.y)
# warning-ignore:narrowing_conversion
	world_tiles_y = ceil(world_tiles_x / screenratio)
	min_terrain_height = world_tiles_y - mod
	max_terrain_height = mod

#	GenerateTerrain()

func Reset_TileMap() -> void:
	## Woraround um die Burg zu behalten
	var Castle = get_used_cells_by_id(1, 6)
	clear_layer(0)
	plattform.clear()
	for i in Castle.size():
		set_cell(1, Castle[i],6, Vector2i(0, 0))
	pass

func GenerateTerrain() -> void:
	Reset_TileMap()

#	rng.seed = "123456789".hash()
	rng.randomize()
	Preloads.UIMain.emit_signal("UITerrainSeedChanged", str(rng.seed))

	current_displacement = displacement
	for x in world_tiles_x:
		if x <= mod:
			current_displacement = displacement
		for y in world_tiles_y:
			if x <= mod and y == current_displacement:
				set_cell(0, Vector2i(x,y), 6, Vector2i(0, 0))
				plattform.append(Vector2i(x, y))
				continue

			# Graslinie
			elif y == current_displacement:
				set_cell(0, Vector2i(x,y), 0, Vector2i(0, 0))

			# Dirt
			if y > current_displacement and y < world_tiles_y-2:
				set_cell(0, Vector2i(x,y), 1, Vector2i(0, 0))

			# Bedrock
			elif y >= world_tiles_y-2:
				set_cell(0, Vector2i(x,y), 7, Vector2i(0, 0))

			var fnl = abs(noise.get_noise_2d(x, y))

		var change_displacement = current_displacement + signi(rng.randi_range(-5, 5))# pow(-1.0, randi() % 2)
		current_displacement = change_displacement
	pass


func generate_world_tilemap_base() -> void:
	GenerateTerrain()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
