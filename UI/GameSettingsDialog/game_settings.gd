extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_butt_start_game_pressed() -> void:
	Config.save_gameconfig()
	if get_tree().change_scene_to_packed(Preloads.MainGameScene) != OK:
		print("Error: change_scene_to()::buttPlay")


func _on_butt_back_to_menu_pressed() -> void:
	if get_tree().change_scene_to_packed(Preloads.MainMenuScene) != OK:
		print("Error: change_scene_to()::buttBackToMenu_pressed")
