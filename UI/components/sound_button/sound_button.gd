extends Button


func _ready():
	if !pressed.is_connected(self._on_pressed):
		if pressed.connect(self._on_pressed) != OK:
			print("Error - soundbutton.gd: connect signal pressed")
		else:
			print("OK - soundbutton.gd: connect signal pressed")
	pass


func on_pressed():
	pass # Replace with function body.


func _on_pressed() -> void:
	$RandomStreamPlayerComponent.play_random()
	print("OK - soundbutton: signal pressed")
