extends KinematicBody2D

signal GroundHit

var velocity = Vector2.ZERO
export var P1 = 1
onready var screensize = get_viewport().get_visible_rect().size

var g = 150
var Ply = ""


func _ready() -> void:
	if !.is_connected("GroundHit", self, "_on_Ground_Hited"):
		assert(.connect("GroundHit", self, "_on_Ground_Hited", [], CONNECT_REFERENCE_COUNTED)==OK, "Fehler1")
	if !SignalBus.is_connected("exploded", self, "_on_Bullet_exploded"):
		assert(SignalBus.connect("exploded", self, "_on_Bullet_exploded", [], CONNECT_REFERENCE_COUNTED)==OK, "Fehler2")


#func _process(_delta):
#	pass


func _physics_process(delta: float) -> void:
	velocity.y += g * delta
	rotation = velocity.angle()
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider is TileMap:
			# Find the character's position in tile coordinates
			var tile_pos = collision.collider.world_to_map(position)
			# Find the colliding tile position
			tile_pos -= collision.normal
			# Get the tile id
			var tile_id = collision.collider.get_cellv(tile_pos)
			if tile_id == 0:
				SignalBus.emit_signal("exploded", position + transform.x * 37)
				emit_signal("GroundHit")
		elif collision.collider is StaticBody2D:
			if collision.collider.is_in_group("Dummy") and collision.collider.has_method("_hit_ByBall"):
				collision.collider._hit_ByBall()
			pass
			
		
		call_deferred("queue_free")
	elif position.x > screensize.x or position.y > screensize.y:
		emit_signal("GroundHit")
		call_deferred("queue_free")
		pass


func _on_Bullet_exploded(pos):
	var e = Preloads.Explosion.instance()
	Preloads.PlayerLeft.add_child(e)
	e.position = pos


func _on_Ground_Hited() -> void:
	SignalBus.emit_signal("UIScoreChange", -2)
