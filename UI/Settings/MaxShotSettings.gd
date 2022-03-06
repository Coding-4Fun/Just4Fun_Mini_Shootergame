extends Control

onready var MaxShotLabel = $labelMaxShots
onready var MaxShotSlider = $MaxShotSlider
onready var MaxShotSwitch = $cButtSwitchMaxShots

func _ready():
	MaxShotLabel.text = str(MaxShotSlider.value)
	MaxShotSwitch.pressed = Config.config_data["Game"]["Condition"]["MaxShotsEnabled"] 
	MaxShotSlider.value = Config.config_data["Game"]["Condition"]["MaxShotsValue"]
	MaxShotSlider.editable = Config.config_data["Game"]["Condition"]["MaxShotsEnabled"]


func _on_MaxShotSlider_value_changed(value):
	MaxShotLabel.text = str(value)
	Config.config_data["Game"]["Condition"]["MaxShotsValue"] = value


func _on_cButtSwitchMaxShots_pressed():
	$MaxShotSlider.editable = !$MaxShotSlider.editable


func _on_cButtSwitchMaxShots_toggled(button_pressed):
	Config.config_data["Game"]["Condition"]["MaxShotsEnabled"] = button_pressed
