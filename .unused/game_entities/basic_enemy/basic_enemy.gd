extends EnemyBase

func _ready():
	super()
	_init_components()
	initiate_properties()
#	EnemyName = "BasicEnemy"
	# Connect Hit Signal
	(_components["hurtbox_component"] as HurtboxComponent).hit.connect(on_hit)
#	monster_resource.EnemyName = "NameChanged"


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
