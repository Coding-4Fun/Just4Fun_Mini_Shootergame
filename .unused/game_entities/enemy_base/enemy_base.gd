extends CharacterBody2D
class_name EnemyBase

@export_subgroup("EnemyProperties")
@export var monster_resource : MonsterPedia
#@export var EnemyName: String = "BasicEnemy"
#@export var weigthness: float = 10.0
#@export var max_health: float = 10.0
#@export_range(0, 1) var drop_percent: float = .5
#@export var max_speed: int = 40
#@export var acceleration: float = 5.0


@export_subgroup("EnemyComponents")
@export var _enemycomponents := {
	"has_health_comp" : false,
	"has_healthbar_comp" : false,
	"has_velocity_comp" : false,
	"has_vialdrop_comp" : false,
	"has_death_comp" : false,
	"has_hitflash_comp" : false,
	"has_hurtbox_comp" : false
}
@export var _components := {}

var is_moving = false
var itemhash : int = 0 :
	set(value):
		itemhash = value
		GameEvents.enemymanager.enemy_table.update_item_weightness_value(itemhash, monster_resource.weigthness)
	get:
		return itemhash
var arena_difficulty : int = 0
var visuals : Node2D


func _ready():
	visuals = get_node_or_null("./Visuals")
#	_init_components()
#	initiate_properties()


func _init_components():
	if _enemycomponents["has_health_comp"]:
		var hc : HealthComponent = GameEvents.get_component("health_component").instantiate()
		_components["health_component"] = hc

	if _enemycomponents["has_healthbar_comp"]:
		_components["healthbar_component"] = GameEvents.get_component("healthbar_component").instantiate()
		_setup_health_component("healthbar_component")

	if _enemycomponents["has_velocity_comp"]:
		var vc : VelocityComponent = GameEvents.get_component("velocity_component").instantiate()
		if is_instance_valid(vc):
			vc.acceleration = monster_resource.acceleration
			vc.max_speed = monster_resource.max_speed
			_components["velocity_component"] = vc

	if _enemycomponents["has_hitflash_comp"]:
		var hfc : HitflashComponent = GameEvents.get_component("hitflash_component").instantiate()
		if is_instance_valid(hfc):
			_components["hitflash_component"] = hfc
			_setup_health_component("hitflash_component")
			hfc.sprite = visuals.get_node("./Sprite2D") as Sprite2D
			_components["hitflash_component"] = hfc

	if _enemycomponents["has_hurtbox_comp"]:
		var hbc : HurtboxComponent = GameEvents.get_component("hurtbox_component").instantiate()
		if is_instance_valid(hbc):
			_components["hurtbox_component"] = hbc
			_setup_health_component("hurtbox_component")

	if _enemycomponents["has_vialdrop_comp"]:
		var vdc : VialdropComponent = GameEvents.get_component("vialdrop_component").instantiate()
		if is_instance_valid(vdc):
			vdc.drop_percent = monster_resource.drop_percent
			_components["vialdrop_component"] = vdc
			_setup_health_component("vialdrop_component")

	if _enemycomponents["has_death_comp"]:
		var dc = GameEvents.get_component("death_component").instantiate() as DeathComponent
		if is_instance_valid(dc):
			_components["death_component"] = dc
			_setup_health_component("death_component")
			dc.sprite = visuals.get_node("./Sprite2D") as Sprite2D
			_components["death_component"] = dc

	for comp in _components:
		var c = _components[comp]
		add_child(c)
		c.owner = self
		_components[comp] = c

	if (self as EnemyBase).has_method("randomize_properties"):
		(self as EnemyBase).randomize_properties()


func _setup_health_component(component_name : String):
	var hc : HealthComponent = (_components["health_component"] as HealthComponent)
	if is_instance_valid(hc) and _components.has(component_name):
		var comp = _components[component_name]
		if is_instance_valid(comp) and "health_component" in comp:
			comp.health_component = hc
			_components[component_name] = comp


func _setup_sprite(component_name : String):
	pass


func get_component(component_name:String):
	if _components.has(component_name):
		return _components[component_name]

	return null


func _process(delta):
	if _enemycomponents["has_velocity_comp"]:
		var vc = _components["velocity_component"]
		if is_instance_valid(vc):
			vc.accelerate_to_player()
			vc.move(self)

		var move_sign = sign(velocity.x)
		if move_sign != 0:
			visuals.scale = Vector2(-move_sign, 1)


# TODO: Move to baseclass
func _process_enemy(delta):
	if is_moving:
		_components["velocity_component"].accelerate_to_player()
	else:
		_components["velocity_component"].decelerate()

	_components["velocity_component"].move(self)

	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func on_hit():
	pass


func set_is_moving(moving: bool):
	pass


func initiate_properties() -> void:
	(_components["health_component"] as HealthComponent).max_health = monster_resource.max_health
	if _enemycomponents.has("has_vialdrop_comp"):
		var vdc = _components["vialdrop_component"] as VialdropComponent
		vdc.drop_percent = monster_resource.drop_percent

	if _enemycomponents.has("has_velocity_comp"):
		var vc = _components["velocity_component"] as VelocityComponent
		vc.max_speed = monster_resource.max_speed
		vc.acceleration = monster_resource.acceleration
