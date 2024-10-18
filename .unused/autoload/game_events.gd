extends Node

signal experience_vial_collected(number: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged

signal enemy_died
signal enemy_spawned

var enemymanager : Enemy_Manager :
	set(value):
		enemymanager = value
	get:
		return enemymanager

#TODO: Implement a ComponentManager

@onready var _components := {
	"death_component" : preload("res://scenes/component/death_component.tscn"),
	"health_component" : preload("res://scenes/component/health_component.tscn"),
	"healthbar_component" : preload("res://scenes/component/health_bar_component.tscn"),
	"pickup_component" : preload("res://scenes/component/pick_up_collection_component.tscn"),
	"velocity_component" : preload("res://scenes/component/velocity_component.tscn"),
	"vialdrop_component" : preload("res://scenes/component/vial_drop_component.tscn"),
	"hitflash_component" : preload("res://scenes/component/hit_flash_component.tscn"),
	"hurtbox_component" : preload("res://scenes/component/hurtbox_component.tscn")
}


func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrades)


func emit_player_damaged():
	player_damaged.emit()

## TODO: Umlagern von main.gd
## nur bei Player
#func on_player_died():
#	var end_screen_instance = end_screen_scene.instantiate()
#	add_child(end_screen_instance)
#	end_screen_instance.set_defeat()
#	MetaProgression.save()


func get_component(component_name) -> PackedScene:
	if _components.has(component_name):
		return _components[component_name]

	return null


#func _on_enemy_died() -> void:
#	pass
