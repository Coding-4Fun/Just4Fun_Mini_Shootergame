extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased

@export var max_health: float = 10.0:
	set(value):
		max_health = value
		current_health = max_health
		health_changed.emit()

var current_health : float = 0.0
var enemymanager:Enemy_Manager


func _ready():
	current_health = max_health
	enemymanager = GameEvents.enemymanager


func damage(damage_amount: float):
	current_health = clamp(current_health - damage_amount, 0, max_health)
	if damage_amount > 0:
		health_changed.emit()
		health_decreased.emit()
		Callable(check_death).call_deferred()


func heal(heal_amount: int):
	damage(-heal_amount)


func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)


func check_death():
	# TODO: Auslagern in EnemyManager für Signae ENemy_died
	# TODO 2: Prüfen ob owner (Dieser Komponente) in group Player ist
	# Signal died auslösen
	if current_health == 0:
		died.emit()
		var o = owner.is_in_group("enemy")
		if not o:
			owner.queue_free()
			return


		if enemymanager.enemies_on_field.has((owner as EnemyBase).monster_resource.EnemyName):
			owner.queue_free()
			enemymanager.enemies_on_field[owner.monster_resource.EnemyName] -= 1
			enemymanager.enemies_on_field["overall"] = get_tree().get_nodes_in_group("enemy").size()

			if enemymanager.enemies_on_field.has("kills"):
				enemymanager.enemies_on_field["kills"] += 1
			else:
				enemymanager.enemies_on_field["kills"] = 1

			GameEvents.enemy_died.emit()
		else:
			print("HealtComponent::check_death() -> Entity not in List: " + (owner as EnemyBase).EnemyName)
