extends Node

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

# UI Signals
signal UIScoreChange

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

	# UI Signals
	UIScoreChange.connect(_on_Dummy_Signal, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Dummy_Signal(_var1=null, _var2=null, _var3=null):
	pass
