extends Control

@onready var MaxScoreLabel : Label = $labelMaxScore
@onready var MaxScoreSlider : HSlider = $MaxScoreSlider
@onready var MaxScoreSwitch : CheckButton = $cButtSwitchMaxScore

func _ready():
	MaxScoreSwitch.button_pressed = Config.get_configdata_value("GameConditionMinMaxScoreEnabled")
	MaxScoreSlider.value = Config.get_configdata_value("GameConditionMinMaxScoreValue")
	MaxScoreSlider.editable = Config.get_configdata_value("GameConditionMinMaxScoreEnabled")
	MaxScoreLabel.text = str(MaxScoreSlider.value)
	
	MaxScoreSwitch.toggled.connect(_on_cButtSwitchMaxScore_toggled)
	MaxScoreSlider.drag_ended.connect(_on_MaxScoreSlider_drag_ended)


func _on_cButtSwitchMaxScore_toggled(toggled_on: bool):
	MaxScoreSlider.editable = toggled_on
	SignalBus.ConfigValueChanged.emit("GameConditionMinMaxScoreEnabled", toggled_on)


func _on_MaxScoreSlider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = MaxScoreSlider.value
		#var minsek:String = "%02.0f" % [int(value) % 60]
		#MaxScoreLabel.text = str(minsek)
		MaxScoreLabel.text = str(value)
		SignalBus.ConfigValueChanged.emit("GameConditionMinMaxScoreValue", value)
