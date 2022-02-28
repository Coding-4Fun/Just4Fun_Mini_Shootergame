extends Node2D

onready var noise
onready var block = preload("res://Terrain/Blocks/Block.tscn")
onready var screensize:Vector2 = get_viewport().get_visible_rect().size
onready var midrange:int = screensize.y
onready var displacement = ceil((midrange / tile_width) / 2)


export var current_displacement = 0
export var castlewidth = 175
#export (float) var displacement = 0
#ceil(midrange / tile_width)
export (float) var smooth = 1.1

enum block_types {
	AIR=-1,
	GRAS = 0,
	DIRT = 1,
	STONE = 2,
	BEDROCK = 3
}


var tile_width = 16
var tile_height = 16
var blocscale:float = 0.25
var surface_height = 64

export (float) var mod = stepify(castlewidth, tile_width) / tile_width

var points = PoolVector2Array()

#export var world_depth = 32
#export var f = 24
#export var chunk_width = 32


var world_tiles_x:int
var screenratio:float
var world_tiles_y:int
var min_terrain_height:int
var max_terrain_height:int


func _ready() -> void:
	world_tiles_x = screensize.x / tile_width
	screenratio = screensize.x / screensize.y
# warning-ignore:narrowing_conversion
	world_tiles_y = round(world_tiles_x / screenratio)
	min_terrain_height = world_tiles_y - mod
	max_terrain_height = mod

#	generate_world()

#	for x in range(0, chunk_width):
#		var y = floor(noise.get_noise_2d((get_global_transform().origin.x/32+x)*.1, 0)*surface_height*.1)
#		print("x: " + str(x) + "/ y: " + str(y))
#		new_block(Vector2(x*32,y*32), block_types.GRAS)
#		for yy in range(y+1, world_depth):
#			new_block(Vector2(x*32, yy*32), block_types.DIRT)
#	pass


func generate_world_block_base() -> void:
	randomize()
	current_displacement = displacement
	for x in world_tiles_x:
		if x < mod:
			current_displacement = displacement
		for y in world_tiles_y:
#			Überspringen
#			if y < current_displacement:
			if y < current_displacement:
				continue
			var new_block = block.instance()

#			BasePlattform
			if x < mod and y == current_displacement:
				new_block.block_type = 1
				points.append(Vector2(x*tile_width, y*tile_height))

#			GrasLine
			if x > mod and y == current_displacement:
				new_block.block_type = 0
				points.append(Vector2(x*tile_width, y*tile_height))
#				new_block.enable_BlockCollision()

#			Midearth
			elif y > current_displacement and y < world_tiles_y-2:
				new_block.block_type = round(rand_range(2,3))

#			Bedrock
			else:
				new_block.block_type = 4

			new_block.translate(Vector2(x*tile_width, y*tile_height))

			new_block.resize_BlockSize(blocscale)
			add_child(new_block)
			if new_block.block_type == block_types.GRAS:
				new_block.enable_BlockCollision()
		current_displacement = current_displacement + sign(rand_range(-1, 2))# pow(-1.0, randi() % 2)
		if current_displacement < max_terrain_height:
			current_displacement += 1
		if current_displacement > min_terrain_height:
			current_displacement -= 1

