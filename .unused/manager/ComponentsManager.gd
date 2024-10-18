extends Node
class_name ComponentsManager


var _ComponentNodes : Dictionary = {
	"death_component" : preload("res://scenes/component/death_component.tscn"),
	"health_component" : preload("res://scenes/component/health_component.tscn"),
	"healthbar_component" : preload("res://scenes/component/health_bar_component.tscn"),
	"pickup_component" : preload("res://scenes/component/pick_up_collection_component.tscn"),
	"velocity_component" : preload("res://scenes/component/velocity_component.tscn"),
	"vialdrop_component" : preload("res://scenes/component/vial_drop_component.tscn"),
	"hitflash_component" : preload("res://scenes/component/hit_flash_component.tscn"),
	"hurtbox_component" : preload("res://scenes/component/hurtbox_component.tscn")
}


func get_scene(component_name : String) -> PackedScene:
	if _ComponentNodes.has(component_name):
		return _ComponentNodes[component_name]

	return null


func get_scene_as_instance(component_name : String) -> Node2D:
	var _comp := get_scene(component_name)
	if is_instance_valid(_comp):
		_comp.get_instance_id()
		return _comp.instantiate()

	return null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
