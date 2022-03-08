extends Node

export var _score:int = 0
export var _hits:int = 0
export var _shots:int = 0

signal GameStateChange

#onready var GameOverDlg = preload("res://UI/GameEndDialog.tscn")

func _ready():
	if !is_connected("GameStateChange", self, "_on_GameStateChange"):
		if connect("GameStateChange", self, "_on_GameStateChange"):
			print("Error - GamestateManager: connect GameStateChange")
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
	# Check auf Max Shots
	if Config.config_data["Game"]["Condition"]["MaxShotsEnabled"]:
		var maxshots = Config.config_data["Game"]["Condition"]["MaxShotsValue"]
		if _shots >= maxshots:
			print("Game Over. You have reached Max Shots")
			_show_GameOverDialog()

	# Check auf Score <> MinMaxScore
	if Config.config_data["Game"]["Condition"]["MinMaxScoreEnabled"]:
		var scorevalue = Config.config_data["Game"]["Condition"]["MinMaxScoreValue"]
		if scorevalue < 0:
			if _score <= scorevalue:
				print("Game Over. You LOOSE. You have reached the minmum Scores")
				_show_GameOverDialog()
		elif scorevalue > 0:
			if _score >= scorevalue:
				print("Game Over. You WON. You have reached the minmum Scores")
				_show_GameOverDialog()


func _show_GameOverDialog(win:bool = false) -> void:
	var go = Preloads.MainGameScene.instance()
	if get_tree().change_scene_to(Preloads.GameOverScene) != OK:
		print("Error: change_scene_to()::GameOver")
	# if win == true:
#		GameOverDialog-WinlooseLabel-text = You Win
#	else
#		GameOverDialog-WinlooseLabel-text = You Loose
