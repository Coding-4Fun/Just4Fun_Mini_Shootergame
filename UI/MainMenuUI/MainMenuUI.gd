extends Control

@onready var random_stream_player_component: Node = $centerContainer/vBoxContainer/RandomStreamPlayerComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	print("GameStart -> RandomSeedGenerator: Seed -> %s" % str(Preloads.rng.seed))
	print("GameStart -> RandomSeedGenerator: State -> %s" % str(Preloads.rng.state))
	print("GameStart -> RandomSeedGenerator: Hash -> %s" % str(hash(Preloads.rng.seed)))
	pass # Replace with function body.


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior


func _on_buttPlay_pressed():
	# Change Scene to GameSettings Scene
	random_stream_player_component.play_random()
	
	ScreenTransition.transition_to_packedscene(Preloads.GameSettingsScene)
	await ScreenTransition.transitioned_halfway


func _on_buttHightScore_pressed():
	# Show Highscore Scene
	pass # Replace with function body.


func _on_buttSettings_pressed():
	# Show Settings Scene
	pass # Replace with function body.


func _on_buttExit_pressed():
	random_stream_player_component.play_random()
	# Close Game, Back to System. Not on HTML
	ScreenTransition.transition(false)
	await ScreenTransition.transitioned_halfway
	notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _on_buttExit_ready():
	if OS.get_name() == "HTML5":
		$centerContainer/vBoxContainer/buttExit.disabled = true
#	else:
#		print("OS: %s" % OS.get_name())
	pass # Replace with function body.
