extends Node

# global signals 
signal FloatingText

# TileMap Signals
signal MapGeneratorGenerateTerrain
signal MapGeneratorPlaceCastle
signal MapGeneratorPlaceCannon

# Cannon Signals
signal CannonPowerChange
signal CannonAngelChange
signal CannonShoot
signal CannonShooting

# CannonBall Signals
signal exploded

#Target Signals
signal CreateAndAddNewTarget
signal TargetHitted
signal GroundHit

# UI Signals
signal UIScoreChange
signal UIResetGame

# settings signals
signal PlayernameChange
signal ConfigValueChanged
signal ConfigSaveDataToFile

# RandomNumberGenerator signals
signal RNGSaveLastState
signal RNGResetLastState

## Dumy func to prevent UNUSED_SIGNAL Warning
func _ready():
	CannonPowerChange.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	CannonAngelChange.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	CannonShoot.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	CannonShooting.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)

	# CannonBall Signals
	exploded.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)

	#Target Signals
	CreateAndAddNewTarget.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	TargetHitted.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	FloatingText.connect(_on_Floating_Text_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	GroundHit.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)

	# UI Signals
	UIScoreChange.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	UIResetGame.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	PlayernameChange.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)

	# Map Generator
	MapGeneratorGenerateTerrain.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	MapGeneratorPlaceCastle.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	MapGeneratorPlaceCannon.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	
	# Config
	ConfigValueChanged.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	ConfigSaveDataToFile.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)

	# RandomNumberGenerator signals
	RNGSaveLastState.connect(_on_RNGSaveLastState, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	RNGResetLastState.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)

func _on_Dummy_Signal(_var1=null, _var2=null, _var3=null):
	pass


func _on_RNGSaveLastState(lastseed : int) -> void:
	SignalBus.ConfigValueChanged.emit("GameMapGeneratorLastState", lastseed)
	pass


func _on_Floating_Text_Signal(text : String, pos : Vector2) -> void:
	#print(text)
	
	var floating_text : Node2D= Preloads.floating_text_scene.instantiate() as Node2D
	var fgl = get_tree().get_first_node_in_group("foreground_layer")
	fgl.add_child(floating_text)

	floating_text.global_position = pos + (Vector2.UP * 16)
	floating_text.start(text)
	pass
