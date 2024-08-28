extends Control

@onready var MaxShotLabel : Label = $labelMaxShots
@onready var MaxShotSlider : HSlider = $MaxShotSlider
@onready var MaxShotSwitch : CheckButton = $cButtSwitchMaxShots

func _ready():
	MaxShotSlider.value = Config.get_configdata_value("GameConditionMaxShotsValue", Variant.Type.TYPE_INT)
	MaxShotLabel.text = str(MaxShotSlider.value)
	MaxShotSwitch.button_pressed = Config.get_configdata_value("GameConditionMaxShotsEnabled", Variant.Type.TYPE_BOOL) 
	MaxShotSlider.editable = Config.get_configdata_value("GameConditionMaxShotsEnabled", Variant.Type.TYPE_BOOL)
	
	MaxShotSlider.drag_ended.connect(_on_MaxShotSlider_drag_ended)
	MaxShotSwitch.toggled.connect(_on_cButtSwitchMaxShots_toggled)


func _on_cButtSwitchMaxShots_toggled(toggled_on: bool):
	$MaxShotSlider.editable = toggled_on
	SignalBus.ConfigValueChanged.emit("GameConditionMaxShotsEnabled", toggled_on)


func _on_MaxShotSlider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = MaxShotSlider.value
		MaxShotLabel.text = str(value)
		SignalBus.ConfigValueChanged.emit("GameConditionMaxShotsValue", value)
