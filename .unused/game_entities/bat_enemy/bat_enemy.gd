extends EnemyBase

func _ready():
	super()
	_init_components()
	initiate_properties()
#	EnemyName = "BatEnemy"
	var hbc = _components["hurtbox_component"] as HurtboxComponent
	hbc.hit.connect(on_hit)


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
