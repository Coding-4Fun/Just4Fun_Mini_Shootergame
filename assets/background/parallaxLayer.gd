extends ParallaxLayer

@export var cloud_speed: float = -25.0


func _process(delta: float) -> void:
	self.motion_offset.x += cloud_speed * delta
