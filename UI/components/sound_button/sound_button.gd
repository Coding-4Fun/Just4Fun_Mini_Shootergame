extends Button


func _ready():
	#pressed.connect(on_pressed)
	pass


func on_pressed():
	pass # Replace with function body.


func _on_pressed() -> void:
	$RandomStreamPlayerComponent.play_random()
