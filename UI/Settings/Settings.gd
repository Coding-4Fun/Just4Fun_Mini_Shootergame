extends Control


func _ready():
    pass

func _on_buttBackToMenu_pressed() -> void:
###	assert(get_tree().change_scene_to(Preloads.MainMenuScene) == OK, "Error: change_scene_to()::buttBackToMenu_pressed")
    if !GSM.GameTimer.is_stopped():
        GSM.GameTimer.stop()

    var current_scene: Node = get_tree().current_scene
    current_scene.queue_free()
    get_tree().current_scene = null

    if get_tree().change_scene_to_packed(Preloads.MainMenuScene) != OK:
        print("Error: change_scene_to()::buttBackToMenu_pressed")
    Config.save_gameconfig()


func _on_visibility_changed():
    if visible:
        SignalBus.GameSettingsOpened.emit()
    else:
        SignalBus.GameSettingsClosed.emit()
