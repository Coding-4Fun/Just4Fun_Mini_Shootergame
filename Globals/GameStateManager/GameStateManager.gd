extends Node

export var _score:int = 0
export var _hits:int = 0
export var _shots:int = 0

var gameWin:int = -1
var pm

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
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().call_group("Shoots", "queue_free")
	var sc = get_tree().change_scene_to(Preloads.GameOverScene)
	if sc != OK:
		print("Error: change_scene_to()::GameOver")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if !get_tree().paused:
			pm = Preloads.PauseMenu.instance()
			get_tree().get_current_scene().add_child(pm)
			pause_mode = Node.PAUSE_MODE_PROCESS
			get_tree().paused = !get_tree().paused
		else:
			get_tree().get_current_scene().get_node("PauseMenu").queue_free()
			pause_mode = Node.PAUSE_MODE_INHERIT
			get_tree().paused = !get_tree().paused

