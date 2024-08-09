extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_butt_start_game_pressed() -> void:
	Config.save_gameconfig()
	if get_tree().change_scene_to_packed(Preloads.MainGameScene) != OK:
		print("Error: change_scene_to()::buttPlay")


func _on_butt_back_to_menu_pressed() -> void:
	var current_scene: Node = get_tree().current_scene
	current_scene.queue_free()
	get_tree().current_scene = null

	if get_tree().change_scene_to_packed(Preloads.MainGameScene) != OK:
		print("Error: change_scene_to()::buttBackToMenu_pressed")
