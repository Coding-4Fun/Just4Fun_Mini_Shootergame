extends Node
class_name UIManager

@onready var _game_scenes : = {
	#Game Menus
	"main_menu": preload("res://scenes/ui/menu/main_menu.tscn"),
	"meta_menu": preload("res://scenes/ui/menu/meta_upgrade/meta_menu.tscn"),
	"monsterpedia_menu": preload("res://scenes/ui/menu/monsterpedia/monsterpedia_menu.tscn"),
	"options_menu": preload("res://scenes/ui/menu/options_menu.tscn"),
	# Ingame Screens
	"upgrade_screen": preload("res://scenes/ui/ingame/upgrade_screen.tscn"),
	"pause_menu": preload("res://scenes/ui/menu/pause_menu.tscn"),
	"end_screen": preload("res://scenes/ui/ingame/end_screen.tscn"),
	# Sub / Shared Scenes
	"ability_update_card_scene": preload("res://scenes/ui/shared/ability_upgrade_card.tscn"),
	"meta_upgrade_card_scene" : preload("res://scenes/ui/menu/meta_upgrade/meta_upgrade_card.tscn"),
	"monsterpedia_card_scene" : preload("res://scenes/ui/menu/monsterpedia/monsterpedia_card.tscn"),
}

var _game_scene_instances : Array[EncodedObjectAsID] = []


func _ready() -> void:
	name = "UiManager"


func get_scene(scene_name : String) -> PackedScene:
	if _game_scenes.has(scene_name):
		return _game_scenes[scene_name]

	return null


func get_scene_as_instance(scene_name : String) -> Node2D:
	var _scene := get_scene(scene_name)
	if not _scene is Object:
		pass
	if is_instance_valid(_scene):
		_scene.get_instance_id()
		return _scene.instantiate()

	return null
