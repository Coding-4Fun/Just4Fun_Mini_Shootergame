extends Control


func _ready():
	pass

func _on_buttBackToMenu_pressed() -> void:
###	assert(get_tree().change_scene_to(Preloads.MainMenuScene) == OK, "Error: change_scene_to()::buttBackToMenu_pressed")
	if !GSM.GameTimer.is_stopped():
		GSM.GameTimer.stop()

	Config.save_gameconfig()
	if get_tree().change_scene_to_packed(Preloads.MainMenuScene) != OK:
		print("Error: change_scene_to()::buttBackToMenu_pressed")
