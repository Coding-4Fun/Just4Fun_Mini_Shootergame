extends Control

## Handle Signals for UI Updates

var _shots : int = 0
var _score : int = 0

signal UIResetGame
signal UIdummyTargetTimerChange

onready var OptionUI = $IngameUIBottom/vBoxContainer/hBoxOptions

func _ready() -> void:
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxShots/labShots.text = str(_shots)
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxScore/labScore.text = str(_score)


# Update UI Label Text when the shootpower changed
func _on_Cannon_CannonAngelChange(newPower : int) -> void:
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxAngel/labAngel.text = str(newPower)


# Update UI Label when the shootangel changed
func _on_Cannon_CannonPowerChange(newAngel : int) -> void:
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxPower/labPower.text = str(newAngel)


func _on_Cannon_Shot() -> void:
	_shots += 1
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxShots/labShots.text = str(_shots)


func _on_UIScore_Change(score) -> void:
	_score += score
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxScore/labScore.text = str(_score)


func _on_button_pressed() -> void:
	_shots = 0
	_score = 0
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxScore/labScore.text = str(_score)
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxShots/labShots.text = str(_shots)
	emit_signal("UIResetGame")


func _on_buttGameOptions_pressed() -> void:
	OptionUI.visible = !OptionUI.visible
	pass # Replace with function body.


func _on_buttSwitchTargetTimer_pressed() -> void:
	emit_signal("UIdummyTargetTimerChange", $IngameUIBottom/vBoxContainer/hBoxOptions/buttSwitchTargetTimer.pressed)
	pass # Replace with function body.
