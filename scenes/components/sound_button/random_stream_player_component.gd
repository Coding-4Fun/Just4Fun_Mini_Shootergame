extends Node

@export var streams: Array[AudioStream]
@export var randomize_pitch = true
@export var min_pitch = .9
@export var max_pitch = 1.1

@onready var player: AudioStreamPlayer = $RandomStreamPlayerComponent

func play_random():
	if streams == null || streams.size() == 0:
		return
		
	if randomize_pitch:
		player.pitch_scale = randf_range(min_pitch, max_pitch)
	else:
		player.pitch_scale = 1

	player.stream = streams.pick_random()
	player.play()
	await player.finished
	pass


func _exit_tree() -> void:
	if player.playing:
		player.stop()
	pass
