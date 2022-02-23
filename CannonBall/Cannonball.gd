extends Area2D

signal exploded
signal GroundHit

var velocity = Vector2.ZERO
export var P1 = 1
onready var screensize = get_viewport().get_visible_rect().size
onready var Main = $"/root/MainGame"

var g = 150

func _ready() -> void:
	var tmp = connect("GroundHit", Main, "_on_Ground_Hited")
	print("Warning Connect: %s" % tmp)


func _process(delta):
	velocity.y += g * delta
	rotation = velocity.angle()
	position += velocity * delta

	if position.y > screensize.y+100 or position.x > screensize.x+100:
		emit_signal("GroundHit")
		queue_free()


func _on_Cannonball_body_entered(body):
	emit_signal("exploded", position + transform.x * 37)
	if body.is_in_group("Dummy") and body.has_method("_hit_ByBall"):
		body._hit_ByBall()
	if body.is_in_group("Ground"):
		emit_signal("GroundHit")
	queue_free()


