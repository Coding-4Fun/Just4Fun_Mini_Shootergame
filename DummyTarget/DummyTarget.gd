extends StaticBody2D


@export var score : int = 1
@export var autoDespawn = true
@export var TimeOut = 0.0
@export var TimeMax = 6.0

@onready var Main = get_tree().get_root().get_node("MainGame")
@onready var label = $dummyLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "0"
	autoDespawn = Config.get_configdata_value("GameDummyTargetTimerEnabled")

	if autoDespawn :
		TimeMax = Config.get_configdata_value("GameDummyTargetTimerCountdown")
		$despawnTimer.start()
	else:
		label.text = "%s" % [score]


func _hit_ByBall():
	$despawnTimer.stop()
	SignalBus.TargetHitted.emit(score)
	queue_free()


func _on_despawnTimer_timeout() -> void:
	label.text = "%s\n%3.2f" % [score, TimeMax]

	if TimeMax <= 0:
		$despawnTimer.stop()
		SignalBus.TargetHitted.emit( score*-1)
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if autoDespawn :
		TimeMax -= delta
