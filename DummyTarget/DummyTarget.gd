extends StaticBody2D

signal Hit

export var score : int = 1

onready var Main = get_tree().get_root().get_node("MainGame")


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


#func _exit_tree() -> void:
#	print("Dummy exit Tree")
#	pass


func _hit_ByBall():
	emit_signal("Hit", score)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
