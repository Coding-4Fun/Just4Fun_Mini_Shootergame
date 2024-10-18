extends Resource
class_name MonsterPedia

@export_subgroup("MonsterPediaInfo")
@export var id: String
@export var max_quantity: int = 1
@export var experience_cost: int = 10
@export var is_unlocked : bool
@export var time_played_to_unlock : int
@export var kills_to_unlock : int
@export var rounds_to_unlock : int
@export var times_enemy_killed : int
@export var enemy_texture : Texture2D
@export var title: String
@export_multiline var description: String

#@export var enemy_scene : PackedScene

@export_subgroup("EnemyProperties")
@export var EnemyName: String = "BasicEnemy"
@export var weigthness: float = 10.0
@export var max_health: float = 10.0
@export_range(0, 1) var drop_percent: float = .5
@export var max_speed: int = 40
@export var acceleration: float = 5.0
