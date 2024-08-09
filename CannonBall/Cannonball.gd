extends CharacterBody2D

signal GroundHit


@export var P1 = 1
@onready var screensize = get_viewport().get_visible_rect().size
@onready var pos_offscreen = $OffscreenPosition

var g = 150
var Ply = ""


func _ready() -> void:
	if !GroundHit.is_connected(_on_Ground_Hited):
		if GroundHit.connect(_on_Ground_Hited.bind(), CONNECT_REFERENCE_COUNTED) != OK:
			print("Error - Cannonball.gd: connect signal GroundHit")

	if !SignalBus.exploded.is_connected(self._on_Bullet_exploded):
		if SignalBus.exploded.connect(_on_Bullet_exploded.bind(), CONNECT_REFERENCE_COUNTED) != OK:
			print("Error - Cannonball.gd: connect signal exploded")


#func _process(_delta):
#	pass


func _physics_process(delta: float) -> void:
	velocity.y += g * delta
	rotation = velocity.angle()
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is TileMap:
			# Find the character's position in tile coordinates
			var colpos = collision.get_position()
			var tile_pos = collider.local_to_map(colpos)
			# Find the colliding tile position
			# Get the tile id
			var tile_id = collider.get_cell_source_id(0,tile_pos)
			if tile_id == 0:
				SignalBus.exploded.emit(position + transform.x * 37)
				GroundHit.emit()
		elif collider is StaticBody2D:
			if collider.is_in_group("Dummy") and collider.has_method("_hit_ByBall"):
				collider._hit_ByBall()
			pass


		call_deferred("queue_free")
	elif position.x > screensize.x or position.y > screensize.y:
		GroundHit.emit()
		call_deferred("queue_free")
		pass


func _on_Bullet_exploded(pos):
	var e = Preloads.Explosion.instantiate()
	Preloads.PlayerLeft.add_child(e)
	e.position = pos


func _on_Ground_Hited() -> void:
	SignalBus.UIScoreChange.emit(-2)


# asteroid script
func _process(_delta) -> void:
	var g_pos = get_global_position()
	var camera_rect = get_viewport().get_visible_rect() # get the rectangle for what the camera can "see"

	# if asteroid is outside camera bounds:
	if g_pos.x < camera_rect.position.x || \
			g_pos.y < 0 || \
			g_pos.x > screensize.x:
#				 || g_pos.y > screensize.y:
		pos_offscreen.show()
		var new_pos = pos_offscreen.get_global_position()
		# clamping ensures indicator stays in visible area of screen
		# sort of a bonus that clamping also ensures indicator is as close to asteroid as possible while still being visible
		new_pos.x = clamp(g_pos.x, 0, screensize.x)
		new_pos.y = clamp(g_pos.y, 0, screensize.y)
		pos_offscreen.set_global_position(new_pos)
#		printt(new_pos.x, new_pos.y)
	else: # asteroid is inside camera bounds
		pos_offscreen.hide()
