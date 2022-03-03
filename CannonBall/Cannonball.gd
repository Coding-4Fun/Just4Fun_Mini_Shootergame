extends KinematicBody2D

signal GroundHit

var velocity = Vector2.ZERO
export var P1 = 1
onready var screensize = get_viewport().get_visible_rect().size
onready var Main = $"/root/MainGame"
var collided = false

var g = 150
var Ply = ""


func _ready() -> void:
	if !.is_connected("GroundHit", self, "_on_Ground_Hited"):
		assert(.connect("GroundHit", self, "_on_Ground_Hited", [], CONNECT_REFERENCE_COUNTED)==OK, "Fehler1")
	if !SignalBus.is_connected("exploded", self, "_on_Bullet_exploded"):
		assert(SignalBus.connect("exploded", self, "_on_Bullet_exploded", [], CONNECT_REFERENCE_COUNTED)==OK, "Fehler2")


func _process(_delta):
#	velocity.y += g * delta
#	rotation = velocity.angle()
#	position += velocity * delta
#
#	if position.y > screensize.y+100 or position.x > screensize.x+100:
#		SignalBus.emit_signal("GroundHit")
#		queue_free()
	pass


func _physics_process(delta: float) -> void:
	velocity.y += g * delta
	rotation = velocity.angle()
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider is TileMap and !collided:
			# Find the character's position in tile coordinates
			var tile_pos = collision.collider.world_to_map(position)
			# Find the colliding tile position
			tile_pos -= collision.normal
			# Get the tile id
			var tile_id = collision.collider.get_cellv(tile_pos)
			print("collide: %s %s" % [name, tile_id])
			if tile_id == 7:
				collided = true
				yield(get_tree(), "idle_frame")
				SignalBus.emit_signal("exploded", position + transform.x * 37)
				.emit_signal("GroundHit")
				$collisionShape2D.disabled = false
#				print("collide: " + name)
			call_deferred("queue_free")
	pass


func _on_Cannonball_body_entered(_body):
	pass


func _on_Bullet_exploded(pos):
	var e = Preloads.Explosion.instance()
	Preloads.PlayerLeft.add_child(e)
	e.position = pos
#	yield(e, "animation_finished")


func _on_Ground_Hited() -> void:
#	if is_queued_for_deletion():
	print("GroundHit: " + name)
	emit_signal("UIScoreChange", -2)


func _on_Cannonball_body_exited(body):
	$collisionShape2D.set_deferred("disabled", true)
	SignalBus.emit_signal("exploded", position + transform.x * 37)
#	yield(get_tree(), "idle_frame")
	call_deferred("queue_free")
	if body.is_in_group("Dummy") and body.has_method("_hit_ByBall"):
		body._hit_ByBall()
	if body.is_in_group("Ground"):
		SignalBus.emit_signal("GroundHit")
#	call_deferred("set", "disabled", "true")
#	yield(get_tree(), "idle_frame")
	queue_free()
	pass # Replace with function body.
