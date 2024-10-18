extends Node
class_name Enemy_Manager

const SPAWN_RADIUS = 375
const MAX_ENEMIES_ON_FIELD : int = 100

#@export var basic_enemy_scene: PackedScene
#@export var wizard_enemy_scene: PackedScene
#@export var bat_enemy_scene: PackedScene
@export var arena_time_manager: Node
var _arena_difficulty := 0
@export var enemy_entities : Array[Resource] = []
#@export var monster_entities : Array[Resource] = []

@onready var timer = $Timer

var base_spawn_time = 0
var enemy_table = WeightedTable.new():
	get:
		return enemy_table
var number_to_spawn = 1:
	set(value):
		number_to_spawn = value
		print("setter() -> num_to_spawn: %d" % number_to_spawn)
		print(get_stack())
var max_enemies_on_field : float = 0.0
var enemies_on_field := {
	"overall": 0,
	"kills": 0,
	"BasicEnemy": 0,
	"WizardEnemy": 0,
	"BatEnemy": 0
}


func _ready():
	GameEvents.enemymanager = self
	print("EnemyManager::_ready() -> num_to_spawn: %d" % number_to_spawn)
	max_enemies_on_field = MAX_ENEMIES_ON_FIELD
	if not enemy_entities.size() > 0:
		push_error("No Enemy Scenes Configured !")

	for item in enemy_entities:
		enemy_table.add_item(item)

	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	# When not set in Inspector
	# TODO: Get it from GameManager
	if not arena_time_manager is ArenatimeManager:
		arena_time_manager = preload("res://scenes/manager/arena_time_manager.tscn").instantiate()
	if is_instance_valid(arena_time_manager):
		arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)

	GameEvents.enemy_died.connect(on_enemy_died)


func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		print("what")
		return Vector2.ZERO

	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		var additional_check_offset = random_direction * 20

		var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)

		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))

	return spawn_position


func on_timer_timeout():
	timer.start()

	# safety clause !
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return

	for i in number_to_spawn:
		var enemycount : int = enemies_on_field["overall"]# enemies_on_field["BasicEnemy"] +enemies_on_field["WizardEnemy"] +enemies_on_field["BatEnemy"]

		if enemycount <= enemycount + number_to_spawn: #max_enemies_on_field:
			var enemy_scene : PackedScene = enemy_table.pick_item([], _arena_difficulty) # * enemy_table.get_count())
			var enemy = enemy_scene.instantiate() as EnemyBase
			enemy.arena_difficulty = _arena_difficulty
			enemy.itemhash = enemy_scene.resource_path.hash()

			var entities_layer = get_tree().get_first_node_in_group("entities_layer")

			if enemies_on_field.has(enemy.monster_resource.EnemyName):
				enemies_on_field[enemy.monster_resource.EnemyName] += 1
			else:
				enemies_on_field[enemy.monster_resource.EnemyName] = 1
			entities_layer.add_child(enemy)
			enemies_on_field["overall"] += 1

			enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	_arena_difficulty = arena_difficulty
	enemy_table.update_weightness.emit(arena_difficulty)

	var time_off :float = (.1 / 12) * arena_difficulty
	max_enemies_on_field = (.1 / 12) * arena_difficulty * MAX_ENEMIES_ON_FIELD
	max_enemies_on_field += randi_range(number_to_spawn,min(arena_difficulty, MAX_ENEMIES_ON_FIELD))
	time_off = min(time_off, .7)
	timer.wait_time = base_spawn_time - time_off

	if (arena_difficulty % 6) == 0:
#		number_to_spawn += randi_range(1,3)
		number_to_spawn += 1

	print("EnemyManager::on_arena_difficulty_increased() -> arena_difficulty %d / num_to_spawn: %d / max_enemies_on_field %d / MAX_ENEMIES_ON_FIELD %d" % [arena_difficulty,number_to_spawn, max_enemies_on_field, MAX_ENEMIES_ON_FIELD])


func on_enemy_died():
	pass
