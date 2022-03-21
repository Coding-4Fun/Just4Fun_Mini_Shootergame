extends Node

# Preload the Assets
onready var Cannon:PackedScene = preload("res://Cannon/Cannon.tscn")
onready var Explosion:PackedScene = preload("res://CannonBall/Explosion.tscn")
onready var DummyTarget:PackedScene = preload("res://DummyTarget/DummyTarget.tscn")
onready var PauseMenu:PackedScene = preload("res://UI/Pause/PauseMenu.tscn")
onready var Bullet = preload("res://CannonBall/Cannonball.tscn")

# Main Game Scene
onready var MainGameScene = preload("res://MainGame.tscn")
onready var MainMenuScene = preload("res://UI/MainMenuUI.tscn")
onready var GameOverScene = preload("res://UI/GameEndDialog.tscn")

# Player Node's
var PlayerRootNode:Node2D
var PlayerLeft:Node2D
var PlayerRight:Node2D
var PlayerShots:Node2D
#
##
var Main:Node2D
#
## UI
var UIMain:Control
#
## Dummys
onready var DummyTargetGroup:Node2D

#
## TileMap
var Map:TileMap


#func _ready():
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
