extends StaticBody2D

var block_sprites = [
	preload("res://Terrain/Blocks/Sprites/cobblestone_mossy.png"),
	preload("res://Terrain/Blocks/Sprites/dirt.png"),
	preload("res://Terrain/Blocks/Sprites/cobblestone.png"),
	preload("res://Terrain/Blocks/Sprites/stonebrick.png")
#	preload("res://Terrain/Blocks/Sprites/Grass (Hill).jpg"),
#	preload("res://Terrain/Blocks/Sprites/coal_ore.png")
]

var block_type

func _ready() -> void :
	get_node("sprite").texture = block_sprites[block_type]
	pass
