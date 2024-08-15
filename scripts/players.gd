extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Player_Shoot(pos:Transform2D, velocity, gravity) -> void:
	randomize()
	var bullet : CharacterBody2D = Preloads.Bullet.instantiate()
	bullet.Ply = name
	bullet.name = str(randi())
	bullet.transform = pos 
	bullet.velocity = bullet.transform.x * velocity # muzzle_velocity
	bullet.g = gravity
	Preloads.PlayerShots.add_child(bullet)
