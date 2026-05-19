extends Node

# Player Node's
var PlayerRootNode: Node2D
var PlayerLeft: Node2D
var PlayerRight: Node2D
var PlayerShots: Node2D
#
##
var Main: Node2D
#
## UI
var UIMain: Control
#
## TileMapLayer's
var TerrainLayer: TileMapLayerBase
var CannonLayer: TileMapLayerBase
var CastleLayer: TileMapLayerBase

# Preload the Assets
@onready var Cannon: PackedScene = preload("uid://lci12xbkaqx2") ## Cannon Object
@onready var DummyTarget: PackedScene = preload("uid://dwpyhrww6jkcv") ## DummyTarget Object
@onready var Bullet: PackedScene = preload("uid://bkuw5djpqvu7i") ## CannonBall Object
# Pre-Load Components
@onready var floating_text_scene: PackedScene = preload("uid://cw7aupmlhq8xo")
@onready var Explosion: PackedScene = preload("uid://xx6yx0io3fgf") ## Explosion Animation Node
# Main Game Scene
@onready var MainGameScene: PackedScene = load("uid://h8vcng8ps4vd")
@onready var MainMenuScene: PackedScene = load("uid://b160gc30aq28t")
@onready var GameSettingsScene: PackedScene = preload("uid://bdg32fb7rseev")
@onready var PauseMenu: PackedScene = preload("uid://cujr5miucacq5")
@onready var GameOverScene: PackedScene = preload("uid://rd0b5nysx6vq")
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
#
## Dummys
@onready var DummyTargetGroup: Node2D


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
