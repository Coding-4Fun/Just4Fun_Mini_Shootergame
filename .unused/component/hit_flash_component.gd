extends Node
class_name HitflashComponent

var health_component: HealthComponent :
	set(value):
		health_component = value
		if is_instance_valid(health_component):
			health_component.health_decreased.connect(on_health_decreased)
		
var sprite: Sprite2D
@export var hit_flash_material: ShaderMaterial

var hit_flash_tween: Tween


func _ready():
#	pass
	sprite.material = hit_flash_material


func on_health_decreased():
	if hit_flash_tween != null && hit_flash_tween.is_valid():
		hit_flash_tween.kill()

	(sprite.material as ShaderMaterial).set_shader_parameter("lerp_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/lerp_percent", 0.0, .25)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
