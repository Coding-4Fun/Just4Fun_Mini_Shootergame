extends Control


@onready var MaxShotLabel : Label = $labelMaxShots
@onready var MaxShotSlider : HSlider = $MaxShotSlider
@onready var DummyTargetTimerSwitch : CheckButton = $cButtSwitchTargetTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#buttSwitchTargetTimer
func _on_c_butt_switch_target_timer_toggled(toggled_on: bool) -> void:
	$centerContainer/vBoxContainer/hBoxContainerMaxGameTimer/MaxGameTimeSlider.editable = toggled_on
	Config.ConfigValueChanged.emit("TimerEnabled", toggled_on, "Game", "DummyTarget")
	pass # Replace with function body.


func _on_max_game_time_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = $centerContainer/vBoxContainer/hBoxContainerMaxGameTimer/MaxGameTimeSlider.value
		Config.ConfigValueChanged.emit("TimerCountdown", value, "Game", "DummyTarget")
