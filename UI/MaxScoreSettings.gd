extends Control

onready var MaxScoreLabel = $labelMaxScore
onready var MaxScoreSlider = $MaxScoreSlider
onready var MaxScoreSwitch = $cButtSwitchMaxScore

func _ready():
	MaxScoreLabel.text = str(MaxScoreSlider.value)
	MaxScoreSwitch.pressed = Config.config_data["Game"]["Condition"]["MinMaxScoreEnabled"] 
	MaxScoreSlider.value = Config.config_data["Game"]["Condition"]["MinMaxScoreValue"]
	MaxScoreSlider.editable = Config.config_data["Game"]["Condition"]["MinMaxScoreEnabled"] 
	pass


func _on_cButtSwitchMaxScore_toggled(button_pressed):
	Config.config_data["Game"]["Condition"]["MinMaxScoreEnabled"] = button_pressed


func _on_MaxScoreSlider_value_changed(value):
	MaxScoreLabel.text = str(value)
	Config.config_data["Game"]["Condition"]["MinMaxScoreValue"] = value


func _on_cButtSwitchMaxScore_pressed():
	$MaxScoreSlider.editable = !$MaxScoreSlider.editable
