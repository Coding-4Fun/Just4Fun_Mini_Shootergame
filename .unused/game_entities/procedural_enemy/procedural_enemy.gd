extends EnemyBase

@export var random_sprites : Array[Texture2D]= []

@export_subgroup("EnemyMaxProperties")
@export var maxrnd_weigthness: float = 10.0:
	set(value):
		if monster_resource != null:
			maxrnd_weigthness = value if value > monster_resource.weigthness else monster_resource.weigthness
		else:
			maxrnd_weigthness = value
@export var maxrnd_max_health: float = 10:
	set(value):
		if monster_resource != null:
			maxrnd_max_health = value if value > monster_resource.max_health else monster_resource.max_health
		else:
			maxrnd_max_health = value
@export_range(0, 1) var maxrnd_drop_percent: float = .5:
	set(value):
		if monster_resource != null:
			maxrnd_drop_percent = value if value > monster_resource.drop_percent else monster_resource.drop_percent
		else:
			maxrnd_drop_percent = value
@export var maxrnd_max_speed: int = 40:
	set(value):
		if monster_resource != null:
			maxrnd_max_speed = value if value > monster_resource.max_speed else monster_resource.max_speed
		else:
			maxrnd_max_speed = value
@export var maxrnd_acceleration: float = 5:
	set(value):
		if monster_resource != null:
			maxrnd_acceleration = value if value > monster_resource.acceleration else monster_resource.acceleration
		else:
			maxrnd_acceleration = value

func _ready():
	super()
	_init_components()
	initiate_properties()
	(_components["hurtbox_component"] as HurtboxComponent).hit.connect(on_hit)
	$Visuals/Sprite2D.texture = randomize_sprite()
	$Visuals/Sprite2D.self_modulate = randomize_modulation()


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()


# randomize initial values
func randomize_sprite() -> Texture2D:
	return random_sprites[randi_range(0, random_sprites.size()-1)]


func randomize_modulation() -> Color:
	var color : Color = Color(
		randf_range(0.0, 1.0),
		randf_range(0.0, 1.0),
		randf_range(0.0, 1.0),
		1
	)
	return color


func randomize_properties() -> void:
	monster_resource.max_health = ceilf(randf_range(monster_resource.max_health, maxrnd_max_health))
	(_components["health_component"] as HealthComponent).max_health = monster_resource.max_health
	monster_resource.drop_percent = ceilf(randf_range(monster_resource.drop_percent, maxrnd_drop_percent))
	monster_resource.max_speed = ceili(randi_range(monster_resource.max_speed, maxrnd_max_speed))
	monster_resource.acceleration = ceilf(randf_range(monster_resource.acceleration, maxrnd_acceleration))
