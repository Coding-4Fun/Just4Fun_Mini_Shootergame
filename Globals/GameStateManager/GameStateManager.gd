extends Node

@export var _score:int = 0
@export var _hits:int = 0
@export var _shots:int = 0

var gameWin:int = -1
var pm:Node
var GameTimer:Timer
var GameTimerTimeElapsed:int = 0
var GameTimeTextLabel:Label
var GameTimerTimeout:int = -1
var IsInGameScene : bool = false

## ToDo: Change to global SignalBus ?
signal GameStateChange


func _ready():
	if !GameStateChange.is_connected(_on_GameStateChange):
		if GameStateChange.connect(_on_GameStateChange):
			print("Error - GamestateManager: connect GameStateChange")

	GameTimer = Timer.new()
	GameTimerTimeout = Config.get_configdata_value("GameConditionMaxGameTimeValue")
	GameTimer.autostart = false
	if GameTimer.timeout.connect(_on_timer_timeout):
		print("Error - GamestateManager: connect GameTimer_timeout")
	add_child(GameTimer)


func _on_timer_timeout() ->void:
	if GSM.gameWin == -1:
		GameTimerTimeElapsed += 1
		if !GameTimer.is_stopped() and GameTimerTimeElapsed >= GameTimerTimeout:
			_check_GameWinCondition()
		if GameTimeTextLabel != null:
			GameTimeTextLabel.text = "%02.0f:%02.0f" % [floor(float(GameTimerTimeElapsed)/60),int(GameTimerTimeElapsed) % 60]
	else:
		GameTimer.stop()


func _on_GameStateChange(newscore, newhits, newshots) -> void:
	_score = newscore
	_shots = newshots
	_hits = newhits
	_check_GameWinCondition()


func _check_GameWinCondition() -> void:
	# Check Game Timeout
	if Config.get_configdata_value("GameConditionMaxGameTimeEnabled"):
		if !GameTimer.is_stopped() and GameTimerTimeElapsed >= GameTimerTimeout:
			print("Game Over. Your Game Time has left.")
			_show_GameOverDialog(3)

	# Check auf Max Shots
	if Config.get_configdata_value("GameConditionMaxShotsEnabled"):
		var maxshots = Config.get_configdata_value("GameConditionMaxShotsValue")
		if _shots >= maxshots:
			print("Game Over. You have reached Max Shots")
			_show_GameOverDialog(1)

	# Check auf Score <> MinMaxScore
	if Config.get_configdata_value("GameConditionMinMaxScoreEnabled"):
		var scorevalue = Config.get_configdata_value("GameConditionMinMaxScoreValue")
		if scorevalue < 0:
			if _score <= scorevalue:
				print("Game Over. You LOOSE. You have reached the minmum Scores")
				_show_GameOverDialog(0)
		elif scorevalue > 0:
			if _score >= scorevalue:
				print("Game Over. You WON. You have reached the Scores")
				_show_GameOverDialog(2)


func _show_GameOverDialog(win:int = 0) -> void:
	gameWin = win
	await get_tree().create_timer(2.0).timeout
	get_tree().call_group("Shoots", "queue_free")

	ScreenTransition.transition_to_packedscene(Preloads.GameOverScene)
	await ScreenTransition.transitioned_halfway



func _input(event: InputEvent) -> void:
	if !IsInGameScene:
		return
	if event.is_action_pressed("Pause"):
		if !get_tree().paused:
			pm = Preloads.PauseMenu.instantiate()
			get_tree().get_current_scene().add_child(pm)
			get_tree().paused = !get_tree().paused
