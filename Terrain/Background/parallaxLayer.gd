extends ParallaxLayer
@export var CLOUD_SPEED : float = -25

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	self.motion_offset.x += CLOUD_SPEED *delta
	pass
