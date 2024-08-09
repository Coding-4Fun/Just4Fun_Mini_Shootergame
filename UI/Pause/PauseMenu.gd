extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if get_tree().paused:
			get_tree().paused = !get_tree().paused
			get_tree().get_current_scene().get_node("PauseMenu").queue_free()
			get_viewport().set_input_as_handled()
