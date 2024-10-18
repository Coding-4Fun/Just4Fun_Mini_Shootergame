extends Node
class_name PickUpCollectionComponent


@onready var collision_pickup_area = $PickupArea2D/CollisionPickupArea

var base_pickup_radius : int = 45


# Called when the node enters the scene tree for the first time.
func _ready():
	var pickuparea_grow_upgrade_count := MetaProgression.get_upgrade_count("pickuparea_grow") as int
	if pickuparea_grow_upgrade_count > 0:
		var new_shape :CircleShape2D = CircleShape2D.new()
		var adjusted_pickuparea_radius := base_pickup_radius * pickuparea_grow_upgrade_count * 0.15
		new_shape.radius = base_pickup_radius + adjusted_pickuparea_radius
		collision_pickup_area.set_shape(new_shape)
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
