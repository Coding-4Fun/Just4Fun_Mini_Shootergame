extends Control

@onready var MaxScoreLabel : Label = $labelMaxScore
@onready var MaxScoreSlider : HSlider = $MaxScoreSlider
@onready var MaxScoreSwitch : CheckButton = $cButtSwitchMaxScore

func _ready():
	MaxScoreLabel.text = str(MaxScoreSlider.value)
	MaxScoreSwitch.button_pressed = Config.config_data["Game"]["Condition"]["MinMaxScoreEnabled"] 
	MaxScoreSlider.value = Config.config_data["Game"]["Condition"]["MinMaxScoreValue"]
	MaxScoreSlider.editable = Config.config_data["Game"]["Condition"]["MinMaxScoreEnabled"] 
	
	MaxScoreSwitch.toggled.connect(_on_cButtSwitchMaxScore_toggled)
	MaxScoreSlider.drag_ended.connect(_on_MaxScoreSlider_drag_ended)
	pass


func _on_cButtSwitchMaxScore_toggled(toggled_on: bool):
	#Config.config_data["Game"]["Condition"]["MinMaxScoreEnabled"] = toggled_on
	MaxScoreSlider.editable = toggled_on
	Config.ConfigValueChanged.emit("MinMaxScoreEnabled", toggled_on, "Game", "DummyTarget")


func _on_MaxScoreSlider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = MaxScoreSlider.value
		var minsek:String = "%02.0f" % [int(value) % 60]
		MaxScoreLabel.text = str(minsek)
		Config.ConfigValueChanged.emit("MinMaxScoreValue", value, "Game", "Condition")
	pass


#func _on_MaxScoreSlider_value_changed(value):
	#MaxScoreLabel.text = str(value)
	#Config.config_data["Game"]["Condition"]["MinMaxScoreValue"] = value


func _on_cButtSwitchMaxScore_pressed():
	$MaxScoreSlider.editable = !$MaxScoreSlider.editable
