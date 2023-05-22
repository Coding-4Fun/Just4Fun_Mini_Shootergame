extends Line2D

@export var displacement = 250
@export var iterations = 5
@export var height = 400
@export var castlewidth = 175
@export var castleleftpos = 0
@export var castlerightpos = 0
@export (float) var smooth = 1.1

var current_displacement

onready var colli = $Terrain/TerrainCollision
onready var root = get_parent()
onready var screensize = get_viewport().get_visible_rect().size

func _ready():
	randomize()
	$Terrain/TerrainPoly.color = default_color
	init_line()


func init_line():
	current_displacement = displacement

	points = PoolVector2Array()
	var start: Vector2
	var end: Vector2

	start = _calculate_StartPointInLine()
	end = _calculate_EndPointInLine()

	add_point(start)
	add_point(end)
	for _i in range(iterations):
		add_points()

## Plattform Links
	set_point_position(0,Vector2(0,start.y))
	set_point_position(1,Vector2(start.x,start.y))

## Plattform rechts
	#add_point(Vector2(screensize.x, end.y))

	colli.polygon = PoolVector2Array()
	var p = points
	p.append(Vector2(screensize.x, screensize.y))
	p.append(Vector2(0, screensize.y))
	$Terrain/TerrainPoly.polygon = p

	colli.polygon = p


func _calculate_StartPointInLine() -> Vector2:
	var start = Vector2(castlewidth, rand_range(height-displacement,
								height+displacement))
	start.y = clamp(start.y, 135, screensize.y-25)
	return start


func _calculate_EndPointInLine() -> Vector2:
	var end = Vector2(screensize.x, rand_range(height-displacement,
								height+displacement))
	end.y = clamp(end.y, 135, screensize.y-25)
	return end


func add_points():
	randomize()
	var old_points = points
	points = PoolVector2Array()
	for i in range(old_points.size() - 1):
		var midpoint = (old_points[i] + old_points[i+1]) / 2
		midpoint.y += current_displacement * pow(-1.0, randi() % 2)
		add_point(old_points[i])
		midpoint.y = clamp(midpoint.y, 135, screensize.y-25)
		add_point(midpoint)
	add_point(old_points[old_points.size() - 1])
	current_displacement *= pow(2.0, -smooth)

####
## Func from MainGame.gd
####
#func add_DummyTarget_to_Line():
#	if Chunk.points.size() < 5:
##	if TerrainLine.points.size() < 5:
#		pass
#
#	var tlSize = Chunk.world_tiles_x
#	var rmin : float = 2
#	var rmax = tlSize-1
#
#	randomize()
#
#	## Zufällige Position wählen
#	var i = rand_range(rmin, rmax)
#
#	target = Dummy.instance()
#	target.position = Chunk.points[int(i)]
#	target.score += int(i)
#	target.get_transform().scaled(Vector2(0.2,0.2))
#	target.autoDespawn = Config.config_data["Game"]["DummyTarget"]["TimerEnabled"]
#
#	if !target.is_connected("Hit", self, "_on_Dummy_Hited"):
#		target.connect("Hit", self, "_on_Dummy_Hited")
