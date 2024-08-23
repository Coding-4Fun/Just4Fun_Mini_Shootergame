extends TileMapLayerBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	world_tiles_x = int(screensize.x / tile_size.x)
	screenratio = screensize.x / screensize.y

	world_tiles_y = ceili(float(world_tiles_x) / screenratio)
	min_terrain_height = world_tiles_y - mod
	max_terrain_height = mod

	SignalBus.MapGenerateWorldTileMap.connect(_on_MapGeneratorWorldTileMap)
	pass # Replace with function body.


func Reset_TileMap() -> void:
	clear()
	pass


func _on_MapGeneratorWorldTileMap() -> void:
	generate_world_tilemap_base()


func generate_world_tilemap_base() -> void:
	Reset_TileMap()
	randomize()
	current_displacement = displacement
	var chgdispl = 0
	for x in world_tiles_x:
		if x <= mod:
			current_displacement = displacement
		for y in world_tiles_y:

			# BasePlattform
			if x <= mod and y == current_displacement:
				set_cell(Vector2i(x,y), 6, Vector2i(0, 0))
				plattform.append(Vector2i(x, y))
				chgdispl = 0
				continue
			# Graslinie
			elif y == current_displacement:
				chgdispl = chgdispl *-1
				if chgdispl == 0:
					set_cell(Vector2i(x,y), 8, Vector2i(0, 0))
				elif chgdispl < 0:
					set_cell(Vector2i(x,y-1), 8, Vector2i(1, 0))
				elif chgdispl > 0:
					set_cell(Vector2i(x,y), 8, Vector2i(2, 0))

			# Dirt für Graslinie + 2
			elif y > current_displacement and y <= current_displacement+2:
				set_cell(Vector2i(x,y-1 if chgdispl < 0 else y), 1, Vector2i(0, 0))

			# Unterhalb der Dirtlinie, zufällige Tiles
			if y > current_displacement+2 and y < world_tiles_y-2:
				var rdm = randi_range(1,5)
				set_cell(Vector2i(x,y-1 if chgdispl < 0 else y), rdm, Vector2i(0, 0))
			# Abschluss Linie , y - 2
			elif y >= world_tiles_y-2:
				set_cell(Vector2i(x,y), 7, Vector2i(0, 0))
			# End Y Loop
		var lastchg = chgdispl
		chgdispl = sign(randi_range(-5, 5))		# -1 || 0 || 1
		if lastchg != 0 and lastchg !=chgdispl:
			chgdispl = 0
		var change_displacement = current_displacement + chgdispl
		current_displacement = change_displacement
