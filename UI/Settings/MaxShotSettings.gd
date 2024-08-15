extends Control

@onready var MaxShotLabel : Label = $labelMaxShots
@onready var MaxShotSlider : HSlider = $MaxShotSlider
@onready var MaxShotSwitch : CheckButton = $cButtSwitchMaxShots

func _ready():
	MaxShotSlider.value = Config.config_data["Game"]["Condition"]["MaxShotsValue"]
	MaxShotLabel.text = str(MaxShotSlider.value)
	MaxShotSwitch.button_pressed = Config.config_data["Game"]["Condition"]["MaxShotsEnabled"] 
	MaxShotSlider.editable = Config.config_data["Game"]["Condition"]["MaxShotsEnabled"]
	
	MaxShotSlider.drag_ended.connect(_on_MaxShotSlider_drag_ended)
	MaxShotSwitch.toggled.connect(_on_cButtSwitchMaxShots_toggled)


	#MaxShotSlider.value_changed.Connect(_on_MaxShotSlider_value_changed)
#func _on_MaxShotSlider_value_changed(value):
	#MaxShotLabel.text = str(value)
	#Config.config_data["Game"]["Condition"]["MaxShotsValue"] = value


	#MaxShotSwitch.pressed.Connect(_on_cButtSwitchMaxShots_pressed)
#func _on_cButtSwitchMaxShots_pressed():
	#$MaxShotSlider.editable = !$MaxShotSlider.editable
	#pass


func _on_cButtSwitchMaxShots_toggled(toggled_on: bool):
	#Config.config_data["Game"]["Condition"]["MaxShotsEnabled"] = button_pressed
	$MaxShotSlider.editable = toggled_on
	Config.ConfigValueChanged.emit("MaxShotsEnabled", toggled_on, "Game", "Condition")


func _on_MaxShotSlider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		var value = MaxShotSlider.value
		MaxShotLabel.text = str(value)
		Config.ConfigValueChanged.emit("MaxShotsValue", value, "Game", "Condition")
	pass
