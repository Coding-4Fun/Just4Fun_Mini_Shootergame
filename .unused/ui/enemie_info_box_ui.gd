extends HBoxContainer
class_name EnemieInfoBoxUI

@onready var label_enemy_name = $EnemiesOnField/LabelEnemyName
@onready var label_kill_count = $EnemiesKillCounter/LabelKillCount

signal EnemySpawned
signal EnemyDied

var EnemyIcon : Sprite2D = Sprite2D.new() :
	set(value):
		EnemyIcon = value
	get:
		return EnemyIcon

var EnemyName : String = "EmptyEnemy" :
	set(value):
		EnemyName = value
	get:
		return EnemyName

var EnemyKillCount : int = 0 :
	set(value):
		EnemyKillCount = value
	get:
		return EnemyKillCount


# Called when the node enters the scene tree for the first time.
func _ready():
	EnemyDied.connect(_on_enemy_died)
	GameEvents.enemy_died.connect(_on_enemy_died)
	GameEvents.enemy_died.connect(_on_enemy_spawned)
	EnemySpawned.connect(_on_enemy_spawned)

	label_enemy_name.text = "Enemies alive: 0.000"
	label_kill_count.text = "Enemies killed: 0.000"
	pass # Replace with function body.


func _on_enemy_spawned():
	pass


func _on_enemy_died():
	if GameEvents.enemymanager.enemies_on_field.has("kills"):
		label_kill_count.text = "Enemies killed: %s " % str(GameEvents.enemymanager.enemies_on_field["kills"])
	else:
		label_kill_count.text = "Enemies killed: 0.000"

	label_enemy_name.text = "Enemies alive: %s " % str(GameEvents.enemymanager.enemies_on_field["overall"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label_enemy_name.text = "Enemies alive: %s " % str(GameEvents.enemymanager.enemies_on_field["overall"])
