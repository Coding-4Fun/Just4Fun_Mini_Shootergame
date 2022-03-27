extends Control

onready var MaxGameTimeLabel = $labelMaxGameTime
onready var MaxGameTimeSlider = $MaxGameTimeSlider
onready var MaxGameTimeSwitch = $cButtSwitchMaxGameTime

func _ready():
	MaxGameTimeLabel.text = str(MaxGameTimeSlider.value)
	MaxGameTimeSwitch.pressed = Config.config_data["Game"]["Condition"]["MaxGameTimeEnabled"] 
	MaxGameTimeSlider.value = Config.config_data["Game"]["Condition"]["MaxGameTimeValue"]
	MaxGameTimeSlider.editable = Config.config_data["Game"]["Condition"]["MaxGameTimeEnabled"]

func _on_MaxTimeSlider_value_changed(value):
#	Umrechnen von Sekunden zur Minuten Anzeige
	var minsek:String = "%02.0f:%02.0f" % [value/60,int(value) % 60]
	MaxGameTimeLabel.text = str(minsek)
	Config.config_data["Game"]["Condition"]["MaxGameTimeValue"] = value


func _on_cButtSwitchMaxGameTime_pressed():
	$MaxGameTimeSlider.editable = !$MaxGameTimeSlider.editable


func _on_cButtSwitchMaxGameTime_toggled(button_pressed):
	Config.config_data["Game"]["Condition"]["MaxGameTimeEnabled"] = button_pressed
