extends ProgressBar
class_name HealthBarComponent

@onready var label: Label = $Label


var health_component : HealthComponent :
	set(new_value):
		if is_instance_valid(new_value):
			health_component = new_value

func _ready() -> void:
	if is_instance_valid(health_component):
		health_component.health_changed.connect(on_health_changed)


func on_health_changed():
	update_health_display()


func update_health_display():
	value = health_component.get_health_percent()
	label.text = str(health_component.current_health) + " / " +str(health_component.max_health)
