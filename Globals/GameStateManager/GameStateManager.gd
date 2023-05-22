extends Node

@export var _score:int = 0
@export var _hits:int = 0
@export var _shots:int = 0

var gameWin:int = -1
var pm
var GameTimer:Timer
var GameTimerTimeElapsed:int = 0
var GameTimeTextLabel:Label

signal GameStateChange

#onready var GameOverDlg = preload("res://UI/GameEndDialog.tscn")

func _ready():
	if !is_connected("GameStateChange", _on_GameStateChange):
		if connect("GameStateChange", _on_GameStateChange):
			print("Error - GamestateManager: connect GameStateChange")
			
	GameTimer = Timer.new()
	if GameTimer.connect("timeout", _on_timer_timeout):
		print("Error - GamestateManager: connect GameTimer_timeout")
	add_child(GameTimer)
	pass


func _on_timer_timeout() ->void:
	if GSM.gameWin == -1:
		GameTimerTimeElapsed += 1
		var timeout = Config.config_data["Game"]["Condition"]["MaxGameTimeValue"]
		if !GameTimer.is_stopped() and GameTimerTimeElapsed >= timeout:
			_check_GameWinCondition()
		if GameTimeTextLabel != null:
			GameTimeTextLabel.text = "%02.0f:%02.0f" % [floor(float(GameTimerTimeElapsed)/60),int(GameTimerTimeElapsed) % 60]
	else:
		GameTimer.stop()
	pass

func _on_GameStateChange(newscore, newhits, newshots) -> void:
	_score = newscore
	_shots = newshots
	_hits = newhits
	_check_GameWinCondition()
	pass

#"Condition": {
#				"MaxShotsEnabled": false,
#				"MaxShotsValue": -0,
#				"MinMaxScoreEnabled": false,
#				"MinMaxScore": -1000
func _check_GameWinCondition() -> void:
	# Check Game Timeout
	if Config.config_data["Game"]["Condition"]["MaxGameTimeEnabled"]:
		var timeout = Config.config_data["Game"]["Condition"]["MaxGameTimeValue"]
		if !GameTimer.is_stopped() and GameTimerTimeElapsed >= timeout:
			print("Game Over. Your Game Time has left.")
			_show_GameOverDialog(3)
		
	# Check auf Max Shots
	if Config.config_data["Game"]["Condition"]["MaxShotsEnabled"]:
		var maxshots = Config.config_data["Game"]["Condition"]["MaxShotsValue"]
		if _shots >= maxshots:
			print("Game Over. You have reached Max Shots")
			_show_GameOverDialog(1)

	# Check auf Score <> MinMaxScore
	if Config.config_data["Game"]["Condition"]["MinMaxScoreEnabled"]:
		var scorevalue = Config.config_data["Game"]["Condition"]["MinMaxScoreValue"]
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
	var sc = get_tree().change_scene_to(Preloads.GameOverScene)
	if sc != OK:
		print("Error: change_scene_to()::GameOver")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if !get_tree().paused:
			pm = Preloads.PauseMenu.instance()
			get_tree().get_current_scene().add_child(pm)
#			pausemode = Node.PROCESS_MODE_PAUSABLE
			get_tree().paused = !get_tree().paused
		else:
			get_tree().get_current_scene().get_node("PauseMenu").queue_free()
#			pause = Node.PAUSE_MODE_INHERIT
#			self.pausemode = Node.PAUSEMODEPROCESS
			get_tree().paused = !get_tree().paused

