extends Node
class_name Game_Manager

var _ManagerInstances : PackedInt32Array = []

var _ManagerNodes : Dictionary = {
	"uimanager" : {
		"scene" : "res://scenes/manager/ui_manager.tscn",
		"instanceIdx" : -1
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for manager in _ManagerNodes.keys():
		var _scene = _ManagerNodes[manager]["scene"]
		print("ManagerNodes : {0}".format([_ManagerNodes]))
		print("manager : {0}".format(([manager])))
		print("scene : {0}".format( [_scene]))
		var instance: Node = load(_scene).instantiate()
		add_child(instance)
		_ManagerInstances.append(instance.get_instance_id())
		_ManagerNodes[manager].instanceIdx = instance.get_instance_id()
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_manager_instance_id(manager_name : String) -> EncodedObjectAsID:
	var mgr : EncodedObjectAsID
	if _ManagerNodes.has(manager_name):
		var node : Dictionary = _ManagerNodes.get("manager_name")
		var iid : int = node["instanceidx"]
		mgr.object_id = _ManagerInstances[iid]

	return mgr
