extends Node

# Preload the Assets
onready var Cannon:PackedScene = preload("res://Cannon/Cannon.tscn")
onready var Explosion:PackedScene = preload("res://CannonBall/Explosion.tscn")
onready var DummyTarget:PackedScene = preload("res://DummyTarget/DummyTarget.tscn")
onready var Bullet = preload("res://CannonBall/Cannonball.tscn")

# Main Game Scene
onready var MainGame = preload("res://MainGame.tscn").instance()
#onready var MainGameUI = preload("res://MainGame.tscn").instance()
onready var MainGameScene = preload("res://MainGame.tscn")
onready var MainMenuScene = preload("res://UI/MainMenuUI.tscn")

# Player Node's
onready var PlayerRootNode = MainGame.get_node("Players")
onready var PlayerLeft = MainGame.find_node("Player1")
onready var PlayerRight = MainGame.find_node("Player2")

# UI
onready var UIMain = MainGame.find_node("InGameUI")

# TileMap
onready var Map = MainGame.find_node("TerrainMap")


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
