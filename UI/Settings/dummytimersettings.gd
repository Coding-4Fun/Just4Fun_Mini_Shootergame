extends Control


@onready var DummyTargetTimeLabel : Label = $labelMaxGameTime
@onready var DummyTargetTimerSwitch : CheckButton = $cButtSwitchTargetTimer
@onready var DummyTargetTimerSlider : HSlider = $MaxGameTimeSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DummyTargetTimerSwitch.toggled.connect(_on_c_butt_switch_target_timer_toggled)
	DummyTargetTimerSlider.drag_ended.connect(_on_max_game_time_slider_drag_ended)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


#buttSwitchTargetTimer
func _on_c_butt_switch_target_timer_toggled(toggled_on: bool) -> void:
	DummyTargetTimerSlider.editable = toggled_on
	Config.ConfigValueChanged.emit("TimerEnabled", toggled_on, "Game", "DummyTarget")
	pass # Replace with function body.


func _on_max_game_time_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = DummyTargetTimerSlider.value
		var minsek:String = "%02.0f" % [int(value) % 60]
		DummyTargetTimeLabel.text = str(minsek)
		Config.ConfigValueChanged.emit("TimerCountdown", value, "Game", "DummyTarget")
