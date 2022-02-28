extends Node

# Preload the Assets
onready var Cannon:PackedScene = preload("res://Cannon/Cannon.tscn")
onready var Explosion:PackedScene = preload("res://CannonBall/Explosion.tscn")
onready var DummyTarget:PackedScene = preload("res://DummyTarget/DummyTarget.tscn")
onready var Bullet = preload("res://CannonBall/Cannonball.tscn")

# Player Node's
onready var PlayerRootNode = $"/root/MainGame/Players"
onready var PlayerLeft = $"/root/MainGame/Players/Player1"
onready var PlayerRight = $"/root/MainGame/Players/Player2"

# UI
onready var UIMain = $"/root/MainGame/InGameUI"

# TileMap
onready var Map = $"/root/MainGame/TerrainMap"

# Main Game Scene
onready var MainGame = preload("res://MainGame.tscn").instance()
#onready var MainGameUI = preload("res://MainGame.tscn").instance()
onready var MainGameScene = preload("res://MainGame.tscn")
onready var MainMenuScene = preload("res://UI/MainMenuUI.tscn")

func _ready():
	# Preload the Assets
# Player Node's
#PlayerRootNode = $"Players"
#PlayerLeft = $Players/Player1
#PlayerRight = $Players/Player2

# UI
#	UIMain = $"/root/MainGame/InGameUI"

# TileMap
#Map = $TerrainMap
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
