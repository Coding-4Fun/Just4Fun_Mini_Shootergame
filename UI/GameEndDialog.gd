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
	if GSM.gameWin:
		winLooseLabel.text = "You have Won"
	else:
		winLooseLabel.text = "You have Loose"
