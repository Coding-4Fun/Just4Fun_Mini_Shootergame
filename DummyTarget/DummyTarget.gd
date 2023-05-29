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
	autoDespawn = Config.config_data["Game"]["DummyTarget"]["TimerEnabled"]

	if autoDespawn :
		$despawnTimer.start()
	else:
		var tmp = "%s"
		label.text = tmp % [score]


func _hit_ByBall():
	$despawnTimer.stop()
	SignalBus.emit_signal("TargetHitted", score)
	queue_free()


func _on_despawnTimer_timeout() -> void:
	var tmp = "%s\n%3.2f"
	label.text = tmp % [score, TimeMax]

	if TimeMax <= 0:
		$despawnTimer.stop()
		SignalBus.emit_signal("TargetHitted", score*-1)
		queue_free()


#func _exit_tree() -> void:
#	print("Dummy exit Tree")
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if autoDespawn :
		TimeMax -= delta

#	pass


#func _enter_tree():
#	print("Dummy - enter_tree(%s)" % str(position))
#
#func _exit_tree():
#	print("Dummy - exit_tree(%s)" % str(position))
