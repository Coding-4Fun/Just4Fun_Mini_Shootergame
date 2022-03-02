extends Area2D


var velocity = Vector2.ZERO
export var P1 = 1
onready var screensize = get_viewport().get_visible_rect().size
onready var Main = $"/root/MainGame"

var g = 150
var Ply = ""


func _ready() -> void:
	assert(SignalBus.connect("GroundHit", self, "_on_Ground_Hited")==OK)
	assert(SignalBus.connect("exploded", self, "_on_Bullet_exploded")==OK)


func _process(delta):
	velocity.y += g * delta
	rotation = velocity.angle()
	position += velocity * delta

	if position.y > screensize.y+100 or position.x > screensize.x+100:
		SignalBus.emit_signal("GroundHit")
		queue_free()


func _on_Cannonball_body_entered(_body):
	pass


func _on_Bullet_exploded(pos):
	var e = Preloads.Explosion.instance()
	Preloads.PlayerLeft.add_child(e)
	e.position = pos
#	yield(e, "animation_finished")


func _on_Ground_Hited() -> void:
	SignalBus.emit_signal("UIScoreChange", -2)


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
#	queue_free()
	pass # Replace with function body.
