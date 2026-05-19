extends Control

var _shots : float = 0
var _score : float = 0
var _hits : float = 0
var _missed : float = 0

@onready var GameHudUI = $BoxContainer/HBoxHudBottom

@onready var texbut_game_menu: TextureButton = $BoxContainer/HBoxHudTop/MarginContainer/hBoxUIButtons/texbutGameMenu

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

	if !SignalBus.UIResetGame.is_connected(self._on_ResetUI):
		if SignalBus.UIResetGame.connect(self._on_ResetUI) != OK:
			print("Error - InGameUI.gd: connect signal CannonShoot")

	texbut_game_menu.pressed.connect(_on_textbutGameMenuPressed)

	var test = Preloads.PlayerLeft.find_child("Cannon")

	$BoxContainer/HBoxHudMiddle/hBoxShots/labShots.text = str(_shots)
	$BoxContainer/HBoxHudMiddle/hBoxHits/labHits.text = str(_hits)
	$BoxContainer/HBoxHudBottom/hBoxMisHits/labMissHits.text = str(_missed)
	$BoxContainer/HBoxHudTop/hBoxScore/labScore.text = str(_score)
	$BoxContainer/HBoxHudTop/hBoxPower/labPower.text = str(test.min_velocity)
	$BoxContainer/HBoxHudMiddle/hBoxPointsPerShot/labPointsPerShots.text = "0.0"

	if Config.get_configdata_value("GameConditionMaxGameTimeEnabled"):
		GSM.GameTimer.start()
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
		$BoxContainer/HBoxHudMiddle/hBoxPointsPerShot/labPointsPerShots.text = "%.3f" % pps
		#$BoxContainer/HBoxHudMiddle/hBoxPointsPerShot/labPointsPerShots
	if score < 0:
		_missed += 1
		$BoxContainer/HBoxHudBottom/hBoxMisHits/labMissHits.text = str(_missed)
	GSM.GameStateChange.emit(_score, _hits, _shots)

## Reset the Game
func _on_ResetUI() -> void:
	_shots = 0.0
	_score = 0.0
	_hits = 0.0
	_missed = 0.0
	$BoxContainer/HBoxHudTop/hBoxScore/labScore.text = str(_score)
	$BoxContainer/HBoxHudMiddle/hBoxShots/labShots.text = str(_shots)
	$BoxContainer/HBoxHudMiddle/hBoxHits/labHits.text = str(_hits)
	$BoxContainer/HBoxHudBottom/hBoxMisHits/labMissHits.text = str(_missed)
	$BoxContainer/HBoxHudMiddle/hBoxPointsPerShot/labPointsPerShots.text = "0.0"
#	SignalBus.UIResetGame.emit()
	GSM.GameTimerTimeElapsed = 0


func _on_textbutGameMenuPressed() -> void:
	# ToDo: Pause Menü öffnen
	var pm = Preloads.PauseMenu.instantiate()
	get_tree().get_current_scene().add_child(pm)
	get_tree().paused = !get_tree().paused
	pass
