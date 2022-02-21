extends Node2D

onready var noise
onready var block = preload("res://Terrain/Blocks/Block.tscn")
onready var screensize:Vector2 = get_viewport().get_visible_rect().size


enum block_types {
	GRAS,DIRT,STONE,BEDROCK
}

var tile_width = 32
var tile_height = 32

export var world_depth = 32
export var f = 24
export var chunk_width = 32

var world_tiles_x:int
var screenratio:float
var world_tiles_y:int

func _ready() -> void:
	world_tiles_x = screensize.x / tile_width
	screenratio = screensize.x / screensize.y
	world_tiles_y = round(world_tiles_x / screenratio)

	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()

	noise.octaves = 3
	noise.period = 3
	noise.persistence = 0.3

	generate_world()

#	for x in range(0, chunk_width):
#		var y = floor(noise.get_noise_2d((get_global_transform().origin.x/32+x)*.1, 0)*surface_height*.1)
#		print("x: " + str(x) + "/ y: " + str(y))
#		new_block(Vector2(x*32,y*32), block_types.GRAS)
#		for yy in range(y+1, world_depth):
#			new_block(Vector2(x*32, yy*32), block_types.DIRT)
	pass

func generate_world() -> void:
	for x in world_tiles_x:
		for y in world_tiles_y:
			var tile = noise.get_noise_2d(x, y)
#			print(tile)
			new_block(Vector2(x, y), tile)
	pass

func new_block(pos:Vector2, type) -> void:
	var new_block = block.instance()
	var t = block_types.GRAS
	new_block.translate(Vector2(pos.x*32, pos.y*32))

	if type < -0.1:
		t = block_types.STONE

	if type < 0.4:
		t = block_types.BEDROCK

	new_block.block_type = t
	add_child(new_block)
	pass
