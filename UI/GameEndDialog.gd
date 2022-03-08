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
	match
	if GSM.gameWin:
		winLooseLabel.text = "You have Won"
	else:
		winLooseLabel.text = "You have Loose"


func _on_buttNewGame_pressed() -> void:
	if get_tree().change_scene_to(Preloads.MainGameScene) != OK:
		print("Error: change_scene_to()::buttPlay")
	pass # Replace with function body.


func _on_buttMainMenu_pressed() -> void:
	if get_tree().change_scene_to(Preloads.MainMenuScene) != OK:
		print("Error: change_scene_to()::buttBackToMenu_pressed")
	pass # Replace with function body.
