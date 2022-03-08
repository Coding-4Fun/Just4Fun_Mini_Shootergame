extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Player_Shoot(pos:Transform2D, velocity, gravity) -> void:
	randomize()
	var bullet = Preloads.Bullet.instance()
	bullet.Ply = name
	bullet.name = str(randi())
#	bullet.add_to_group("Shoots")
	bullet.transform = pos #Muzzle.global_transform
	bullet.velocity = bullet.transform.x * velocity # muzzle_velocity
	bullet.g = gravity
	Preloads.PlayerShots.add_child(bullet)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
