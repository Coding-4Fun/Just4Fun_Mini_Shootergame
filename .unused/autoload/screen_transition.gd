extends CanvasLayer

signal transitioned_halfway

@export var skip_emit = false

@onready var animation_player = $AnimationPlayer
@onready var color_rect = $ColorRect

func _ready() -> void:
	animation_player.animation_finished.connect(on_animation_finished)


func on_animation_finished(anim: String):
	color_rect.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	pass


func on_animation_started():
	color_rect.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
	pass


# USed when add a menu as child in Scene
func transition():
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
	transitioned_halfway.emit()
	$AnimationPlayer.play_backwards("default")


func transition_to_packedscene(packed_scene: PackedScene):
	transition()
	await transitioned_halfway
	get_tree().change_scene_to_packed(packed_scene)
	await $AnimationPlayer.animation_finished
	pass


# used to change activ scene
func transition_to_scene(scene_path: String):
	transition()
	await transitioned_halfway
	get_tree().change_scene_to_file(scene_path)
	await $AnimationPlayer.animation_finished


func emit_transitioned_halfway():
	if skip_emit:
		skip_emit = false
		return
	transitioned_halfway.emit()
