extends CanvasLayer

@onready var butt_continue: Button = $CenterContainer/colorRect/VBoxContainer/ButtContinue
@onready var butt_restart_level: Button = $CenterContainer/colorRect/VBoxContainer/ButtRestartLevel
@onready var butt_new_level: Button = $CenterContainer/colorRect/VBoxContainer/ButtNewLevel
@onready var butt_back_to_settings: Button = $CenterContainer/colorRect/VBoxContainer/ButtBackToSettings
@onready var butt_back_to_main_menu: Button = $CenterContainer/colorRect/VBoxContainer/ButtBackToMainMenu
@onready var butt_back_to_desktop: Button = $CenterContainer/colorRect/VBoxContainer/ButtBackToDesktop



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	butt_continue.pressed.connect(_on_ButtContinuePressed)
	butt_restart_level.pressed.connect(_on_ButtRestartLevelPressed)
	butt_new_level.pressed.connect(_on_ButtNewLevelPressed)
	butt_back_to_settings.pressed.connect(_on_ButtBackToSettingsPressed)
	butt_back_to_main_menu.pressed.connect(_on_ButtBackToMainMenuPressed)
	butt_back_to_desktop.pressed.connect(_on_ButtBackToDesktopPresse)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		if get_tree().paused:
			get_tree().paused = !get_tree().paused
			queue_free()
			get_viewport().set_input_as_handled()


func _on_ButtContinuePressed() -> void:
	if get_tree().paused:
		get_tree().paused = !get_tree().paused
		queue_free()
	pass


func _on_ButtRestartLevelPressed() -> void:
	# Unpause
	if get_tree().paused:
		get_tree().paused = !get_tree().paused
		queue_free()
	# ResetUI
	SignalBus.UIResetGame.emit()
	# Reset GameTimer if enabled
	## Reset Seed to Beginning
	pass


func _on_ButtNewLevelPressed() -> void:
	pass


func _on_ButtBackToSettingsPressed() -> void:
	pass


func _on_ButtBackToMainMenuPressed() -> void:
	pass


func _on_ButtBackToDesktopPresse() -> void:
	pass
