extends EnemyBase

func _ready():
	super()
	_init_components()
	initiate_properties()
	(_components["hurtbox_component"] as HurtboxComponent).hit.connect(on_hit)



func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
