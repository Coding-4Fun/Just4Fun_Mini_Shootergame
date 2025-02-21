extends Node

# Preload the Assets
@onready var Cannon:PackedScene = preload("res://Cannon/Cannon.tscn")
@onready var Explosion:PackedScene = preload("res://CannonBall/Explosion.tscn")
@onready var DummyTarget:PackedScene = preload("res://DummyTarget/DummyTarget.tscn")
@onready var PauseMenu:PackedScene = preload("res://UI/Pause/PauseMenu.tscn")
@onready var Bullet :PackedScene = preload("res://CannonBall/Cannonball.tscn")
@onready var floating_text_scene :PackedScene = preload("res://UI/components/floating_text/floating_text.tscn")

# Main Game Scene
@onready var MainGameScene :PackedScene = load("res://MainGameScene/MainGame.tscn")
@onready var MainMenuScene :PackedScene = load("res://UI/MainMenuUI/MainMenuUI.tscn")
@onready var GameSettingsScene :PackedScene = preload("res://UI/GameSettingsDialog/GameSettings.tscn")
@onready var GameOverScene :PackedScene = preload("res://UI/GameEndDialog/GameEndDialog.tscn")

@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()

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
@onready var DummyTargetGroup:Node2D

#
## TileMapLayer's
var TerrainLayer: TileMapLayerBase
var CannonLayer:  TileMapLayerBase
var CastleLayer:  TileMapLayerBase


func _ready():
	SignalBus.RNGResetLastState.connect(_on_RNGResetLastState, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	pass


func _on_RNGResetLastState() -> void:
	rng.state = Config.get_configdata_value("GameMapGeneratorLastState", Variant.Type.TYPE_INT)
	pass


## Load from Config or Set Default value
func _initRNG() -> void:
	var _seed = Config.get_configdata_value("GameMapGeneratorSeed")
	if typeof(_seed) == Variant.Type.TYPE_INT:
		rng.seed = _seed 
	else:
		rng.seed = 212197721011977
		SignalBus.ConfigValueChanged.emit("GameMapGeneratorSeed", rng.seed)
		SignalBus.ConfigValueChanged.emit("GameMapGeneratorState", rng.state)
	pass # Replace with function body.
