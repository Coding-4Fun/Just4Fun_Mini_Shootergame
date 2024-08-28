extends Control

@onready var butt_start_game: Button = $centerContainer/vBoxContainer/hBoxButtons/buttStartGame
@onready var butt_back_to_menu: Button = $centerContainer/vBoxContainer/hBoxButtons/buttBackToMenu
@onready var line_edit_user_name: LineEdit = $centerContainer/vBoxContainer/HBoxPlayername/LineEditUserName
@onready var tex_butt_generate_random_seed: TextureButton = $centerContainer/vBoxContainer/VBoxTerrainSeed/HBoxPlayername/TexButtGenerateRandomSeed
@onready var line_edit_generate_random_seed: LineEdit = $centerContainer/vBoxContainer/VBoxTerrainSeed/HBoxPlayername/LineEditGenerateRandomSeed
@onready var tex_butt_copy_seed: TextureButton = $centerContainer/vBoxContainer/VBoxTerrainSeed/HBoxPlayername/TexButtCopySeed
@onready var tex_butt_paste_seed: TextureButton = $centerContainer/vBoxContainer/VBoxTerrainSeed/HBoxPlayername/TexButtPasteSeed


var playerhaschange : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	butt_start_game.pressed.connect(_on_butt_start_game_pressed)
	butt_back_to_menu.pressed.connect(_on_butt_back_to_menu_pressed)
	
	tex_butt_generate_random_seed.pressed.connect(_on_tex_butt_generate_random_seed)
	#line_edit_generate_random_seed.text_changed.connect(_on_line_edit_generate_random_seed_changed)
	
	line_edit_user_name.text_changed.connect(_on_playername_change)
	line_edit_user_name.text = Config.get_configdata_value("GamePlayerName", Variant.Type.TYPE_STRING)

	tex_butt_copy_seed.pressed.connect(_on_tex_butt_copy_seed)
	tex_butt_paste_seed.pressed.connect(_on_tex_butt_paste_seed)
	
	print("GameSettings -> RandomSeedGenerator: Seed -> %s" % str(Preloads.rng.seed))
	print("GameSettings -> RandomSeedGenerator: State -> %s" % str(Preloads.rng.state))
	print("GameSettings -> RandomSeedGenerator: Hash -> %s" % str(hash(Preloads.rng.seed)))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_butt_start_game_pressed() -> void:
	if playerhaschange:
		SignalBus.ConfigValueChanged.emit("GamePlayerName", line_edit_user_name.text)
	print("GameSettings Seed: %s" % str(Preloads.rng.seed))
	SignalBus.ConfigSaveDataToFile.emit()
	ScreenTransition.transition_to_packedscene(Preloads.MainGameScene)
	
	await ScreenTransition.transitioned_halfway


func _on_butt_back_to_menu_pressed() -> void:
	ScreenTransition.transition_to_packedscene(Preloads.MainMenuScene)
	await ScreenTransition.transitioned_halfway


func _on_playername_change(_newname:String) -> void:
	playerhaschange = true


func _on_tex_butt_generate_random_seed() -> void:
	#Preloads.rng.randomize()
	
	line_edit_generate_random_seed.text = str(Preloads.rng.randi())
	#signi()
	print("RandomSeedGenerator: Number -> %s" % line_edit_generate_random_seed.text)
	print("RandomSeedGenerator: Seed -> %s" % str(Preloads.rng.seed))
	print("RandomSeedGenerator: State -> %s" % str(Preloads.rng.state))
	print("RandomSeedGenerator: Hash -> %s" % str(hash(Preloads.rng.seed)))
	pass


func _on_tex_butt_copy_seed() -> void:
	DisplayServer.clipboard_set(line_edit_generate_random_seed.text)
	pass


func _on_tex_butt_paste_seed() -> void:
	line_edit_generate_random_seed.text = DisplayServer.clipboard_get()
	pass
