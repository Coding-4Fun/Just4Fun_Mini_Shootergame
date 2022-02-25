extends Node2D

signal UIScoreChange
signal CannonReset


#onready var TerrainLine = $"TerrainLine"
onready var Chunk = $"Chunk"

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
var target


func _ready():
	cannonLeft.connect("CannonAngelChange", UIMain, "_on_Cannon_CannonAngelChange")
	cannonLeft.connect("CannonPowerChange", UIMain, "_on_Cannon_CannonPowerChange")
	cannonLeft.connect("CannonShoot", UIMain, "_on_Cannon_Shot")
	if !is_connected("UIScoreChange", UIMain, "_on_UIScore_Change"):
		var _res = connect("UIScoreChange", UIMain, "_on_UIScore_Change")
	UIMain.connect("UIResetGame", self, "_on_UI_ResetGame")
	UIMain.connect("UIdummyTargetTimerChange", Config, "_on_dummytarget_TimerChange")
	var tmp = connect("CannonReset", cannonLeft, "_reset_CannonPower")
	if (tmp) != OK:
		print("Connect MainGame::_ready() -> Connect to CannonReset Fehlgeschlagen: %s" % tmp)

	$Chunk.generate_world_tilemap_base()
#	$Chunk.generate_world_block_base()


func add_cannon_left(pos:Vector2 = Vector2.INF):
#	cannonLeft.position = TerrainLine.points[0]
#	cannonLeft.position.x = TerrainLine.castlewidth / 2
	if pos == Vector2.INF:
		cannonLeft.position = Chunk.points[round(Chunk.mod / 2)]
		cannonLeft.position.x = Chunk.castlewidth / 2
		PlayerLeft.add_child(cannonLeft)
	else:
		cannonLeft.position.x = pos


func add_DummyTarget():
	if Chunk.points.size() < 5:
#	if TerrainLine.points.size() < 5:
		pass

	var tlSize = Chunk.world_tiles_x
	var rmin : float = 2
	var rmax = tlSize-1

	randomize()

	## Zufällige Position wählen
	var i = rand_range(rmin, rmax)

	target = Dummy.instance()
	target.position = Chunk.points[int(i)]
	target.score += int(i)
	target.get_transform().scaled(Vector2(0.2,0.2))
	target.autoDespawn = Config.config_data["Game"]["DummyTarget"]["TimerEnabled"]

	if !target.is_connected("Hit", self, "_on_Dummy_Hited"):
		target.connect("Hit", self, "_on_Dummy_Hited")

	call_deferred("add_child", target)


func _on_MainGame_ready() -> void:
#	add_cannon_left()
#	add_DummyTarget()
	pass


func _on_Dummy_Hited(score : int) -> void:
	emit_signal("UIScoreChange", score)
	add_DummyTarget()

func _on_Ground_Hited() -> void:
	emit_signal("UIScoreChange", -2)


func _on_UI_ResetGame() -> void:
	print("Main: UIResetGame_Signal")
#	ToDo:
#	Vor dem generieren bei Reset
#	Erst die alten Blocks entfernen
#	Chunk.generate_world()
#	TerrainLine.init_line()
	get_tree().call_group("Dummy", "queue_free")
	get_tree().call_group("Shoots", "queue_free")
	yield(get_tree(), "idle_frame")
	emit_signal("CannonReset")
	add_DummyTarget()
#	cannonLeft.position = TerrainLine.points[0]
#	cannonLeft.position.x = TerrainLine.castlewidth / 2
	var pos:Vector2 = Chunk.points[0]
	pos.x = Chunk.castlewidth / 2

	add_cannon_left(pos)


func _on_Bullet_exploded(pos):
	var e = Explosion.instance()
	add_child(e)
	e.position = pos
#	tank.can_shoot = true
#	line.hide()


#func update_trajectory():
#	line.clear_points()
#	var v = barrel.global_transform.x * tank.bullet_speed
#	var p = muzzle.global_position
#	for i in num_points:
#		line.add_point(p)
#		v.y += tank.gravity * dt
#		p += v * dt
#		if p.y > $Ground.position.y - 25:
#			break
#	pass


#func add_Castles():
#	castleleft.position = TerrainLine.points[0]
#	castleleft.modulate = Color.red
#
#	castleright.position = TerrainLine.points[TerrainLine.points.size()-2]
#	castleright.modulate = Color.green
#
#	add_child(castleleft)
#	add_child(castleright)
#	pass


#func _on_TerrainLine_ready() -> void:
#	pass


#func _on_TerrainLine_tree_entered() -> void:
#	pass
