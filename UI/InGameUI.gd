extends Control

## Handle Signals for UI Updates

var _shots : float = 0
var _score : float = 0

signal UIResetGame
signal UIdummyTargetTimerChange

onready var OptionUI = $IngameUIBottom/vBoxContainer/hBoxOptions

func _ready() -> void:
	if !SignalBus.is_connected("CannonAngelChange", self, "_on_Cannon_CannonAngelChange"):
		assert(SignalBus.connect("CannonAngelChange", self, "_on_Cannon_CannonAngelChange")==OK)
	if !SignalBus.is_connected("UIScoreChange", self, "_on_UIScore_Change"):
		assert(SignalBus.connect("UIScoreChange", self, "_on_UIScore_Change")==OK)
	if !SignalBus.is_connected("CannonPowerChange", self, "_on_Cannon_CannonPowerChange"):
		assert(SignalBus.connect("CannonPowerChange", self, "_on_Cannon_CannonPowerChange") == OK)

	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxShots/labShots.text = str(_shots)
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxScore/labScore.text = str(_score)
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxPointsPerShot/labPointsPerShots.text = "0.0"



# Update UI Label Text when the shootpower changed
func _on_Cannon_CannonAngelChange(newAngel : int) -> void:
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxAngel/labAngel.text = str(newAngel)


# Update UI Label when the shootangel changed
func _on_Cannon_CannonPowerChange(newPower : int) -> void:
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxPower/labPower.text = str(newPower)


func _on_Cannon_Shot() -> void:
	_shots += 1
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxShots/labShots.text = str(_shots)


func _on_UIScore_Change(score) -> void:
	_score += score
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxScore/labScore.text = str(_score)
	if _shots != 0:
		var pps:float = float(float(_score) / float(_shots))
		$IngameUIBottom/vBoxContainer/hBoxHud/hBoxPointsPerShot/labPointsPerShots.text = "%.3f" % pps


func _on_button_pressed() -> void:
	_shots = 0.0
	_score = 0.0
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxScore/labScore.text = str(_score)
	$IngameUIBottom/vBoxContainer/hBoxHud/hBoxShots/labShots.text = str(_shots)
	emit_signal("UIResetGame")


func _on_buttGameOptions_pressed() -> void:
	OptionUI.visible = !OptionUI.visible
	pass # Replace with function body.


func _on_buttSwitchTargetTimer_pressed() -> void:
	emit_signal("UIdummyTargetTimerChange", $IngameUIBottom/vBoxContainer/hBoxOptions/buttSwitchTargetTimer.pressed)
	pass # Replace with function body.


func _on_buttBackToMenu_pressed() -> void:
	if get_tree().change_scene_to(Preloads.MainMenuScene) != OK:
		print("Error: change_scene_to()::buttBackToMenu_pressed")

