extends Control

var _shots : float = 0
var _score : float = 0
var _hits : float = 0
var _missed : float = 0

## Holds the background size 
## x = w/o Settings
## y = w/ Settings
@export var _backgroundMin := Vector2i(130,220)

## Handle Signals for UI Updates
signal UIResetGame
signal UIdummyTargetTimerChange


@onready var OptionUI = $BoxContainer/VBoxSetting
@onready var GameHudUI = $BoxContainer/HBoxHudMiddle
@onready var background: ColorRect = $Background


func _ready() -> void:
	if !SignalBus.CannonAngelChange.is_connected(self._on_Cannon_CannonAngelChange):
		if SignalBus.CannonAngelChange.connect(self._on_Cannon_CannonAngelChange) != OK:
			print("Error - InGameUI.gd: connect signal CannonAngelChange")

	if !SignalBus.UIScoreChange.is_connected(self._on_UIScore_Change):
		if SignalBus.UIScoreChange.connect(self._on_UIScore_Change) != OK:
			print("Error - InGameUI.gd: connect signal UIScoreChange")

	if !SignalBus.CannonPowerChange.is_connected(_on_Cannon_CannonPowerChange):
		if SignalBus.CannonPowerChange.connect(_on_Cannon_CannonPowerChange, ConnectFlags.CONNECT_PERSIST | ConnectFlags.CONNECT_DEFERRED) != OK:
			print("Error - InGameUI.gd: connect signal CannonPowerChange")

	if !SignalBus.CannonShoot.is_connected(self._on_Cannon_Shot):
		if SignalBus.CannonShoot.connect(self._on_Cannon_Shot) != OK:
			print("Error - InGameUI.gd: connect signal CannonShoot")
#
	#if !UIdummyTargetTimerChange.is_connected(Config._on_dummytarget_TimerChange):
		#if UIdummyTargetTimerChange.connect(Config._on_dummytarget_TimerChange) != OK:
			#print("Error - InGameUI.gd: connect signal UIdummyTargetTimerChange")

	var test = Preloads.PlayerLeft.find_child("Cannon")

	$BoxContainer/HBoxHudMiddle/hBoxShots/labShots.text = str(_shots)
	$BoxContainer/HBoxHudMiddle/hBoxHits/labHits.text = str(_hits)
	$BoxContainer/HBoxHudBottom/hBoxMisHits/labMissHits.text = str(_missed)
	$BoxContainer/HBoxHudTop/hBoxScore/labScore.text = str(_score)
	$BoxContainer/HBoxHudTop/hBoxPower/labPower.text = str(test.min_velocity)
	$BoxContainer/HBoxHudBottom/hBoxPointsPerShot/labPointsPerShots.text = "0.0"

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
	GSM.GameStateChange.emit(_score, _hits, _shots)


func _on_UIScore_Change(score) -> void:
	_score += score
	$BoxContainer/HBoxHudTop/hBoxScore/labScore.text = str(_score)

	if score > 0:
		_hits += 1
		$BoxContainer/HBoxHudMiddle/hBoxHits/labHits.text = str(_hits)
	if _shots != 0:
		var pps:float = float(float(_score) / float(_shots))
		$BoxContainer/HBoxHudBottom/hBoxPointsPerShot/labPointsPerShots.text = "%.3f" % pps
	if score < 0:
		_missed += 1
		$BoxContainer/HBoxHudBottom/hBoxMisHits/labMissHits.text = str(_missed)
	GSM.GameStateChange.emit(_score, _hits, _shots)

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
	UIResetGame.emit()
	GSM.GameTimerTimeElapsed = 0

# Öffnen und schliessen der Settings
func _on_buttGameOptions_pressed() -> void:
	Config.save_gameconfig()

	OptionUI.visible = !OptionUI.visible

	if OptionUI.visible:
		background.size.y = _backgroundMin.y
	else:
		background.size.y = _backgroundMin.x

	if Config.get_configdata_value("GameConditionMaxGameTimeEnabled") == true and OptionUI.visible == false:
		GSM.GameTimer.start()

	$"BoxContainer/HBoxHudMiddle/hBoxGametimer".visible = !GSM.GameTimer.is_stopped()


func _on_buttSwitchTargetTimer_pressed() -> void:
	UIdummyTargetTimerChange.emit($BoxContainer/VBoxSetting/hBoxOptions/buttSwitchTargetTimer.button_pressed)


func _on_butt_back_to_menu_pressed() -> void:
###	assert(get_tree().change_scene_to(Preloads.MainMenuScene) == OK, "Error: change_scene_to()::buttBackToMenu_pressed")
	if !GSM.GameTimer.is_stopped():
		GSM.GameTimer.stop()

	Config.save_gameconfig()
	if get_tree().change_scene_to_packed(Preloads.MainMenuScene) != OK:
		print("Error: change_scene_to()::buttBackToMenu_pressed")
