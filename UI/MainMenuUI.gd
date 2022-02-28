extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit() # default behavior


func _on_buttPlay_pressed():
	# Change Scene to Game Scene
#	get_tree().get_root().add_child(Preloads.MainGame)
	get_tree().change_scene_to(Preloads.MainGameScene)
#	call_deferred("get_tree().get_root().remove_child()", self)
	pass # Replace with function body.


func _on_buttHightScore_pressed():
	# Show Highscore Scene
	pass # Replace with function body.


func _on_buttSettings_pressed():
	# Show Settings Scene
	pass # Replace with function body.


func _on_buttExit_pressed():
	# Close Game, Back to System. Not on HTML
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)