extends Control

@onready var CannonReloadTimeLabel : Label = $labelCannonReloadTime
@onready var CannonReloadTimeSlider : HSlider = $MaxGameTimeSlider
@onready var CannonReloadTimeSwitch : CheckButton = $cButtSwitchCannonReloadCooldown

func _ready():
	CannonReloadTimeLabel.text = str(CannonReloadTimeSlider.value)
	#MaxGameTimeSwitch.button_pressed = Config.config_data["Game"]["Condition"]["MaxGameTimeEnabled"]
	#MaxGameTimeSlider.value = Config.config_data["Game"]["Condition"]["MaxGameTimeValue"]
	#MaxGameTimeSlider.editable = Config.config_data["Game"]["Condition"]["MaxGameTimeEnabled"]

	CannonReloadTimeSwitch.button_pressed = Config.get_configdata_value("GameConditionCannonReloadTimerEnabled")
	CannonReloadTimeSlider.value = Config.get_configdata_value("GameConditionCannonReloadTimer")
	CannonReloadTimeLabel.text = str("00:%02.0f" % [int(CannonReloadTimeSlider.value)])
	CannonReloadTimeSlider.editable = Config.get_configdata_value("GameConditionCannonReloadTimerEnabled")

	CannonReloadTimeSwitch.toggled.connect(_on_c_butt_switch_cannon_reload_time_toggled)
	CannonReloadTimeSlider.drag_ended.connect(_on_cannon_reload_time_slider_drag_ended)


func _on_c_butt_switch_cannon_reload_time_toggled(toggled_on: bool) -> void:
	CannonReloadTimeSlider.editable = toggled_on

	SignalBus.ConfigValueChanged.emit("GameConditionCannonReloadTimerEnabled", toggled_on)
	pass # Replace with function body.


func _on_cannon_reload_time_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = CannonReloadTimeSlider.value
		var minsek:String = "00:%02.0f" % [int(value)]
		CannonReloadTimeLabel.text = str(minsek)
		SignalBus.ConfigValueChanged.emit("GameConditionCannonReloadTimer", value)


#func _on_MaxTimeSlider_value_changed(value):
##	Umrechnen von Sekunden zur Minuten Anzeige
	#var minsek:String = "%02.0f:%02.0f" % [floor(value/60),int(value) % 60]
	#MaxGameTimeLabel.text = str(minsek)
	#Config.config_data["Game"]["Condition"]["MaxGameTimeValue"] = value


#func _on_cButtSwitchMaxGameTime_pressed():
	#$MaxGameTimeSlider.editable = !$MaxGameTimeSlider.editable


func _on_cButtSwitchMaxGameTime_toggled(_button_pressed):
	#Config.config_data["Game"]["Condition"]["MaxGameTimeEnabled"] = button_pressed
	#SignalBus.ConfigValueChanged.emit("GameConditionCannonReloadTimerEnabled", button_pressed)
	#if !GSM.GameTimer.is_stopped() and !button_pressed:
		#GSM.GameTimer.stop()
		#GSM.GameTimerTimeElapsed = 0
	pass
