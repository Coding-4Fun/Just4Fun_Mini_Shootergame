extends Control

onready var MaxShotLabel = $"labelMaxShots"
onready var MaxShotSlider = $"MaxShotSlider"
onready var MaxShotSwitchr = $"cButtSwitchMaxShots"

func _ready():
	MaxShotLabel.text = str(MaxShotSlider.value)
	MaxShotSwitchr.pressed = Config.config_data["Game"]["Condition"]["MaxShotsEnabled"] 
	MaxShotSlider.value = Config.config_data["Game"]["Condition"]["MaxShotsValue"]
	pass


func _on_MaxShotSlider_value_changed(value):
	MaxShotLabel.text = str(value)
	Config.config_data["Game"]["Condition"]["MaxShotsValue"] = value
	pass # Replace with function body.


func _on_cButtSwitchMaxShots_pressed():
	$MaxShotSlider.editable = !$MaxShotSlider.editable
	
	pass # Replace with function body.


func _on_cButtSwitchMaxShots_toggled(button_pressed):
	Config.config_data["Game"]["Condition"]["MaxShotsEnabled"] = button_pressed
	pass # Replace with function body.
