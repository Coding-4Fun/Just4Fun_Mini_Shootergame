extends StaticBody2D

#	AIR=-1,
#	GRAS = 0,
#	DIRT = 1,
#	STONE = 2,
#	BEDROCK = 3

var block_sprites = [
	preload("res://Terrain/Blocks/Sprites/gras.png"),
	preload("res://Terrain/Blocks/Sprites/stonebrick.png"),
	preload("res://Terrain/Blocks/Sprites/dirt.png"),
	preload("res://Terrain/Blocks/Sprites/cobblestone.png"),
	preload("res://Terrain/Blocks/Sprites/cobblestone_mossy.png")
#	preload("res://Terrain/Blocks/Sprites/Grass (Hill).jpg"),
#	preload("res://Terrain/Blocks/Sprites/coal_ore.png")
]

var block_type := 1 : set = _on_set_blocktype
var debugtext := "" : set = _on_set_debugtext

@onready var labDebug = $sprite/labDEBUG
var togglecollision

func _ready() -> void :
	if block_type == -1:
		visible = false
		return

	togglecollision = $collisionShape2D
	get_node("sprite").texture = block_sprites[block_type]
	pass


func _on_set_blocktype(type) -> void:
	block_type = type
	pass


func _on_set_debugtext(text) -> void:
		labDebug.text = text


func resize_BlockSize(_scale_:float) -> void:
	scale *= _scale_


func enable_BlockCollision() -> void:
	if block_type == 0:
		togglecollision.disabled = false
	#!togglecollision.set_deferred("Disabled", togglecollision.Disabled)
