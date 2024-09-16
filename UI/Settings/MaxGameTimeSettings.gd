extends Control

@onready var MaxGameTimeLabel = $labelMaxGameTime
@onready var MaxGameTimeSlider : HSlider = $MaxGameTimeSlider
@onready var MaxGameTimeSwitch : CheckButton = $cButtSwitchMaxGameTime

func _ready():
	MaxGameTimeLabel.text = str(MaxGameTimeSlider.value)
	#MaxGameTimeSwitch.button_pressed = Config.config_data["Game"]["Condition"]["MaxGameTimeEnabled"] 
	#MaxGameTimeSlider.value = Config.config_data["Game"]["Condition"]["MaxGameTimeValue"]
	#MaxGameTimeSlider.editable = Config.config_data["Game"]["Condition"]["MaxGameTimeEnabled"]
	
	MaxGameTimeSwitch.button_pressed = Config.get_configdata_value("GameConditionMaxGameTimeEnabled")
	MaxGameTimeSlider.value = Config.get_configdata_value("GameConditionMaxGameTimeValue")
	MaxGameTimeLabel.text = str("%02.0f:%02.0f" % [floor(MaxGameTimeSlider.value/60),int(MaxGameTimeSlider.value) % 60])
	MaxGameTimeSlider.editable = Config.get_configdata_value("GameConditionMaxGameTimeEnabled")

	MaxGameTimeSwitch.toggled.connect(_on_c_butt_switch_max_game_time_toggled)
	MaxGameTimeSlider.drag_ended.connect(_on_max_game_time_slider_drag_ended)


func _on_c_butt_switch_max_game_time_toggled(toggled_on: bool) -> void:
	MaxGameTimeSlider.editable = toggled_on

	SignalBus.ConfigValueChanged.emit("GameConditionMaxGameTimeEnabled", toggled_on)
	pass # Replace with function body.


func _on_max_game_time_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = MaxGameTimeSlider.value
		var minsek:String = "%02.0f:%02.0f" % [floor(value/60),int(value) % 60]
		MaxGameTimeLabel.text = str(minsek)
		SignalBus.ConfigValueChanged.emit("GameConditionMaxGameTimeValue", value)


#func _on_MaxTimeSlider_value_changed(value):
##	Umrechnen von Sekunden zur Minuten Anzeige
	#var minsek:String = "%02.0f:%02.0f" % [floor(value/60),int(value) % 60]
	#MaxGameTimeLabel.text = str(minsek)
	#Config.config_data["Game"]["Condition"]["MaxGameTimeValue"] = value


#func _on_cButtSwitchMaxGameTime_pressed():
	#$MaxGameTimeSlider.editable = !$MaxGameTimeSlider.editable


func _on_cButtSwitchMaxGameTime_toggled(button_pressed):
	#Config.config_data["Game"]["Condition"]["MaxGameTimeEnabled"] = button_pressed
	SignalBus.ConfigValueChanged.emit("GameConditionMaxGameTimeEnabled", button_pressed)
	if !GSM.GameTimer.is_stopped() and !button_pressed:
		GSM.GameTimer.stop()
		GSM.GameTimerTimeElapsed = 0
