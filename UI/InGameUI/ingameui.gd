extends Control

## Handle Signals for UI Updates

var _shots : float = 0
var _score : float = 0
var _hits : float = 0
var _missed : float = 0

var _backgroundMin := Vector2i(130,350)

signal UIResetGame
signal UIdummyTargetTimerChange

@onready var OptionUI = $BoxContainer/VBoxSetting
@onready var GameHudUI = $BoxContainer/HBoxHudMiddle
@onready var background: ColorRect = $Background


func _ready() -> void:
	if !SignalBus.is_connected("CannonAngelChange", self._on_Cannon_CannonAngelChange):
###		assert(SignalBus.connect("CannonAngelChange", self, "_on_Cannon_CannonAngelChange")==OK)
		if SignalBus.connect("CannonAngelChange", self._on_Cannon_CannonAngelChange) != OK:
			print("Error - InGameUI.gd: connect signal CannonAngelChange")

	if !SignalBus.is_connected("UIScoreChange", self._on_UIScore_Change):
###		assert(SignalBus.connect("UIScoreChange", self, "_on_UIScore_Change")==OK)
		if SignalBus.connect("UIScoreChange", self._on_UIScore_Change) != OK:
			print("Error - InGameUI.gd: connect signal UIScoreChange")

	if !SignalBus.is_connected("CannonPowerChange", self._on_Cannon_CannonPowerChange):
###		assert(SignalBus.connect("CannonPowerChange", self, "_on_Cannon_CannonPowerChange") == OK)
		if SignalBus.connect("CannonPowerChange", self._on_Cannon_CannonPowerChange) != OK:
			print("Error - InGameUI.gd: connect signal CannonPowerChange")

	if !SignalBus.is_connected("CannonShoot", self._on_Cannon_Shot):
###		assert(SignalBus.connect("CannonShoot", self, "_on_Cannon_Shot") == OK)
		if SignalBus.connect("CannonShoot", self._on_Cannon_Shot) != OK:
			print("Error - InGameUI.gd: connect signal CannonShoot")

	if !is_connected("UIdummyTargetTimerChange", Config._on_dummytarget_TimerChange):
###		assert(connect("UIdummyTargetTimerChange", Config, "_on_dummytarget_TimerChange") == OK)
		if connect("UIdummyTargetTimerChange", Config._on_dummytarget_TimerChange) != OK:
			print("Error - InGameUI.gd: connect signal UIdummyTargetTimerChange")

	var test = Preloads.PlayerLeft.find_child("Cannon")

	$BoxContainer/HBoxHudMiddle/hBoxShots/labShots.text = str(_shots)
	$BoxContainer/HBoxHudMiddle/hBoxHits/labHits.text = str(_hits)
	$BoxContainer/HBoxHudBottom/hBoxMisHits/labMissHits.text = str(_missed)
	$BoxContainer/HBoxHudTop/hBoxScore/labScore.text = str(_score)
	$BoxContainer/HBoxHudTop/hBoxPower/labPower.text = str(test.min_velocity)
	$BoxContainer/HBoxHudBottom/hBoxPointsPerShot/labPointsPerShots.text = "0.0"

	$BoxContainer/VBoxSetting/hBoxOptions/buttSwitchTargetTimer.button_pressed = Config.config_data["Game"]["DummyTarget"]["TimerEnabled"]

	GSM.GameTimeTextLabel = GameHudUI.get_node("hBoxGametimer/labelGameTime")
	GSM.GameTimerTimeElapsed = 0


# Update UI Label Text when the shootpower changed
func _on_Cannon_CannonAngelChange(newAngel : int) -> void:
	$"BoxContainer/HBoxHudTop/hBoxAngel/labAngel".text = str(newAngel)


# Update UI Label when the shootangel changed
func _on_Cannon_CannonPowerChange(newPower : int) -> void:
	$BoxContainer/HBoxHudTop/hBoxPower/labPower.text = str(newPower)


func _on_Cannon_Shot() -> void:
	_shots += 1
	$BoxContainer/HBoxHudMiddle/hBoxShots/labShots.text = str(_shots)
	GSM.emit_signal("GameStateChange", _score, _hits, _shots)


func _on_UIScore_Change(score) -> void:
	_score += score
	$BoxContainer/HBoxHudTop/hBoxScore/labScore.text = str(_score)
	# GSM.emit_signal("GameStateChange", _score, _hits, _shots)
	if score > 0:
		_hits += 1
		$BoxContainer/HBoxHudMiddle/hBoxHits/labHits.text = str(_hits)
	if _shots != 0:
		var pps:float = float(float(_score) / float(_shots))
		$BoxContainer/HBoxHudBottom/hBoxPointsPerShot/labPointsPerShots.text = "%.3f" % pps
	if score < 0:
		_missed += 1
		$BoxContainer/HBoxHudBottom/hBoxMisHits/labMissHits.text = str(_missed)
	GSM.emit_signal("GameStateChange", _score, _hits, _shots)

## Reset the Game
func _on_buttGameReset_button_pressed() -> void:
	_shots = 0.0
	_score = 0.0
	_hits = 0.0
	_missed = 0.0
	$BoxContainer/HBoxHudTop/hBoxScore/labScore.text = str(_score)
	$BoxContainer/HBoxHudMiddle/hBoxShots/labShots.text = str(_shots)
	$BoxContainer/HBoxHudMiddle/hBoxHits/labHits.text = str(_hits)
	$BoxContainer/HBoxHudBottom/hBoxMisHits/labMissHits.text = str(_missed)
	$BoxContainer/HBoxHudBottom/hBoxPointsPerShot/labPointsPerShots.text = "0.0"
	emit_signal("UIResetGame")
	GSM.GameTimerTimeElapsed = 0

# Öffnen und schliessen der Settings
func _on_buttGameOptions_pressed() -> void:
	Config.save_gameconfig()

	OptionUI.visible = !OptionUI.visible

	if OptionUI.visible:
		background.size.y = _backgroundMin.y
	else:
		background.size.y = _backgroundMin.x

	if Config.config_data["Game"]["Condition"]["MaxGameTimeEnabled"] == true and OptionUI.visible == false:
		GSM.GameTimer.start()

	$"BoxContainer/HBoxHudMiddle/hBoxGametimer".visible = !GSM.GameTimer.is_stopped()


func _on_buttSwitchTargetTimer_pressed() -> void:
	emit_signal("UIdummyTargetTimerChange", $BoxContainer/VBoxSetting/hBoxOptions/buttSwitchTargetTimer.button_pressed)
