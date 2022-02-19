extends StaticBody2D

signal Hit

export var score : int = 1
export var autoDespawn = true
export var TimeOut = 0.0
export var TimeMax = 6.0

onready var Main = get_tree().get_root().get_node("MainGame")
onready var label = $dummyLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "0"
	if autoDespawn :
		$despawnTimer.start()
	else:
		var tmp = "%s"
		label.text = tmp % [score]


func _hit_ByBall():
	emit_signal("Hit", score)
	queue_free()


func _on_despawnTimer_timeout() -> void:
	var tmp = "%s\n%3.2f"
	label.text = tmp % [score, TimeMax]

	if TimeMax <= 0:
		$despawnTimer.stop()
		emit_signal("Hit", score*-1)
		queue_free()



#func _exit_tree() -> void:
#	print("Dummy exit Tree")
#	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	TimeMax -= delta
#	pass
