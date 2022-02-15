extends Area2D

signal exploded

var velocity = Vector2.ZERO
export var P1 = 1
onready var screensize = get_viewport().get_visible_rect().size

var g = 150

func _process(delta):
	velocity.y += g * delta
	rotation = velocity.angle()
	position += velocity * delta

	if position.y > screensize.y+100:
		queue_free()
	if position.x > screensize.x+100:
		queue_free()


func _on_Cannonball_body_entered(body):
	emit_signal("exploded", position + transform.x * 37)
	if body.is_in_group("Dummy"):
		body.queue_free()
	queue_free()


