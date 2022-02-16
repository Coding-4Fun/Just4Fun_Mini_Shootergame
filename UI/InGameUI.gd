extends Control

## Handle Signals for UI Updates

var _shots : int = 0
var _score : int = 0

signal UIResetGame

func _ready() -> void:
	$IngameUIBottom/vBoxContainer/hBoxShots/labShots.text = str(_shots)
	$IngameUIBottom/vBoxContainer/hBoxScore/labScore.text = str(_score)


# Update UI Label Text when the shootpower changed
func _on_Cannon_CannonAngelChange(newPower : int) -> void:
	$IngameUIBottom/vBoxContainer/hBoxAngel/labAngel.text = str(newPower)


# Update UI Label when the shootangel changed
func _on_Cannon_CannonPowerChange(newAngel : int) -> void:
	$IngameUIBottom/vBoxContainer/hBoxPower/labPower.text = str(newAngel)


func _on_Cannon_Shot() -> void:
	_shots += 1
	$IngameUIBottom/vBoxContainer/hBoxShots/labShots.text = str(_shots)


func _on_UIScore_Change(score) -> void:
	_score += score
	$IngameUIBottom/vBoxContainer/hBoxScore/labScore.text = str(_score)


func _on_button_pressed() -> void:
	_shots = 0
	_score = 0
	$IngameUIBottom/vBoxContainer/hBoxScore/labScore.text = str(_score)
	$IngameUIBottom/vBoxContainer/hBoxShots/labShots.text = str(_shots)
	emit_signal("UIResetGame")
