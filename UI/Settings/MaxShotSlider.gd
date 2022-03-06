extends Control

onready var MaxShotLabel = $"labelMaxShots"
onready var MaxShotSlider = $"MaxShotSlider"

func _ready():
	MaxShotLabel.text = str(MaxShotSlider.value)
	pass


func _on_MaxShotSlider_value_changed(value):
	MaxShotLabel.text = str(value)
	pass # Replace with function body.


func _on_cButtSwitchMaxShots_pressed():
	$MaxShotSlider.editable = !$MaxShotSlider.editable
	pass # Replace with function body.
