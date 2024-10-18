extends EnemyBase


func _ready():
	super()
#	monster_resource.EnemyName = "WizardEnemy"
	_init_components()
	initiate_properties()
	var hbc = _components["hurtbox_component"] as HurtboxComponent
	hbc.hit.connect(on_hit)


func _process(delta):
	if is_moving:
		_components["velocity_component"].accelerate_to_player()
	else:
		_components["velocity_component"].decelerate()

	_components["velocity_component"].move(self)

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func set_is_moving(moving: bool):
	is_moving = moving


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
