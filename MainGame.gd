extends Node2D

signal UIScoreChange

onready var TerrainLine = $"TerrainLine"

onready var Players = $Players
onready var PlayerLeft = $Players/Player1
onready var PlayerRight = $Players/Player2

#onready var castle = preload("res://Castle2d.tscn")
#onready var castleleft = castle.instance()
#onready var castleright = castle.instance()

onready var cannon = preload("res://Cannon/Cannon.tscn")

onready var cannonLeft = cannon.instance()
onready var cannonBarrelLeft = cannonLeft.get_node("Barrel")
onready var cannonBarrelLeftMuzzle = cannonBarrelLeft.get_node("Muzzle")

#onready var cannonRight = cannon.instance()
#onready var cannonBarrelRight = cannonRight.get_node("Barrel")
#onready var cannonBarrelRightMuzzle = cannonBarrelRight.get_node("Muzzle")

onready var UIMain = $InGameUI

onready var line = $TrajectoryLine
var Explosion = preload("res://CannonBall/Explosion.tscn")
var Dummy = preload("res://DummyTarget/DummyTarget.tscn")


func _ready():
	cannonLeft.connect("CannonAngelChange", UIMain, "_on_Cannon_CannonAngelChange")
	cannonLeft.connect("CannonPowerChange", UIMain, "_on_Cannon_CannonPowerChange")
	cannonLeft.connect("CannonShoot", UIMain, "_on_Cannon_Shot")
	connect("UIScoreChange", UIMain, "_on_UIScore_Change")
	pass


func add_cannon_left():
	cannonLeft.position = TerrainLine.points[0]
	cannonLeft.position.x = TerrainLine.castlewidth / 2
	PlayerLeft.add_child(cannonLeft)


func add_DummyTarget():
	if TerrainLine.points.size() < 5:
		pass
	randomize()
	var tlSize = TerrainLine.points.size() -3
	var rmin : float = 2
	var rmax = tlSize

	var i = rand_range(rmin, rmax)
	var t = Dummy.instance()
	t.position = TerrainLine.points[int(i)]
	t.score += int(i)
	t.get_transform().scaled(Vector2(0.2,0.2))
	t.connect("Hit", self, "_on_Dummy_Hited")
	call_deferred("add_child", t)

#	for i in TerrainLine.points.size()-3:
#		if pow(-1.0, randi() % 2) == 1:
#			var t = Dummy.instance()
#			t.position = TerrainLine.points[i+2]
#			t.get_transform().scaled(Vector2(0.2,0.2))
#			add_child(t)


func update_trajectory():
#	line.clear_points()
#	var v = barrel.global_transform.x * tank.bullet_speed
#	var p = muzzle.global_position
#	for i in num_points:
#		line.add_point(p)
#		v.y += tank.gravity * dt
#		p += v * dt
#		if p.y > $Ground.position.y - 25:
#			break
	pass


func _on_Bullet_exploded(pos):
	var e = Explosion.instance()
	add_child(e)
	e.position = pos
#	tank.can_shoot = true
#	line.hide()


func add_Castles():
#	castleleft.position = TerrainLine.points[0]
#	castleleft.modulate = Color.red
#
#	castleright.position = TerrainLine.points[TerrainLine.points.size()-2]
#	castleright.modulate = Color.green
#
#	add_child(castleleft)
#	add_child(castleright)
	pass


func _on_TerrainLine_ready() -> void:
#	print("Line2d Meldet Ready")
#	add_cannon_left()
	pass


func _on_MainGame_ready() -> void:
	add_cannon_left()
	add_DummyTarget()


func _on_Dummy_Hited(score : int) -> void:
	emit_signal("UIScoreChange", score)
	add_DummyTarget()


func _on_TerrainLine_tree_entered() -> void:
	pass
