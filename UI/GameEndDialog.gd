extends Control

var winLooseText:String = "value" setget set_WinLoose_Text
onready var winLooseLabel = $marginContainer/centerContainer/vBoxContainer/labGameOverTitel/labWinLoose


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DisplayText()


func set_WinLoose_Text(value) -> void:
	winLooseText = value
	DisplayText()


func DisplayText() -> void:
	match GSM.gameWin:
		0:	# Maximum Minus Score
			winLooseLabel.text = "You have Loose"
		
		1:	# Max Shots Limit
			winLooseLabel.text = "You have Won\nBy Shots"
			
		2:	# Maxumim Score
			winLooseLabel.text = "You have Won\n By Score"
		_:	# -1 by default
			winLooseLabel.text = "Just End the Game"


func _on_buttNewGame_pressed() -> void:
	if get_tree().change_scene_to(Preloads.MainGameScene) != OK:
		print("Error: change_scene_to()::buttPlay")
	pass # Replace with function body.


func _on_buttMainMenu_pressed() -> void:
	if get_tree().change_scene_to(Preloads.MainMenuScene) != OK:
		print("Error: change_scene_to()::buttBackToMenu_pressed")
	pass # Replace with function body.
