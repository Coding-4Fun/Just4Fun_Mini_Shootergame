extends ParallaxLayer
export(float) var CLOUD_SPEED = -25.0

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	self.motion_offset.x += CLOUD_SPEED *delta
	pass
