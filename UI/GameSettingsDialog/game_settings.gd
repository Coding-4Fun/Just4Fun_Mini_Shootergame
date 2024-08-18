extends Control

@onready var butt_start_game: Button = $centerContainer/vBoxContainer/hBoxButtons/buttStartGame
@onready var butt_back_to_menu: Button = $centerContainer/vBoxContainer/hBoxButtons/buttBackToMenu
@onready var line_edit_user_name: LineEdit = $centerContainer/vBoxContainer/HBoxPlayername/LineEditUserName

var playerhaschange : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	butt_start_game.pressed.connect(_on_butt_start_game_pressed)
	butt_back_to_menu.pressed.connect(_on_butt_back_to_menu_pressed)
	line_edit_user_name.text_changed.connect(_on_playername_change)

	line_edit_user_name.text = Config.get_configdata_value("GamePlayerName", Variant.Type.TYPE_STRING)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_butt_start_game_pressed() -> void:
	if playerhaschange:
		Config.ConfigValueChanged.emit("GamePlayerName", line_edit_user_name.text)
		
	Config.save_gameconfig()
	ScreenTransition.transition_to_packedscene(Preloads.MainGameScene)
	await ScreenTransition.transitioned_halfway


func _on_butt_back_to_menu_pressed() -> void:
	ScreenTransition.transition_to_packedscene(Preloads.MainMenuScene)
	await ScreenTransition.transitioned_halfway


func _on_playername_change(_newname:String) -> void:
	playerhaschange = true
