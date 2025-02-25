extends Node2D

@export var left:bool = true

@export var muzzle_velocity : int = 1500
@export var min_velocity = 10000
@export var max_velocity = 60000
@export var gravity = 250
@export var cooldown_tick := 3

var cooldown := 3
var can_shoot := true
var current_rotation := 0

@onready var Muzzle = get_node("Barrel/Muzzle")
@onready var Barrel = get_node("Barrel")
@onready var coolDown = get_node("CoolDown")
@onready var cooldowntimer: Timer = $Timer


func _ready():
	if !SignalBus.CannonShoot.is_connected( Preloads.UIMain._on_Cannon_Shot):
		if SignalBus.CannonShoot.connect(Preloads.UIMain._on_Cannon_Shot) != OK:
			print("Error - Cannon.gd: connect signal CannonShoot")

	if !SignalBus.CannonShooting.is_connected(Preloads.PlayerShots._on_Player_Shoot):
		if SignalBus.CannonShooting.connect(Preloads.PlayerShots._on_Player_Shoot)!=OK:
			print("Error - Cannon.gd: connect signal CannonShooting")
	
	SignalBus.MapGeneratorPlaceCannon.connect(_on_MapGenerator_PlaceCannon)
	
	coolDown.max_value = 60.0 * cooldown
	cooldown_tick = cooldown


func _unhandled_input(event):
	if GSM.gameWin != -1:
		return
	if event.is_action_released("cannon_shoot") and can_shoot:
		SignalBus.CannonShooting.emit(Muzzle.global_transform, muzzle_velocity, gravity)
		SignalBus.CannonShoot.emit()
		SignalBus.FloatingText.emit(str(cooldown_tick), global_position)
		cooldowntimer.start()
		can_shoot = false
	if event.is_action_released("cannon_power_plus"):
		if Input.is_key_pressed(KEY_CTRL):
			muzzle_velocity = clamp(muzzle_velocity+1000, min_velocity, max_velocity)
		else:
			muzzle_velocity = clamp(muzzle_velocity+100, min_velocity, max_velocity)
		SignalBus.CannonPowerChange.emit(muzzle_velocity)
	if event.is_action_released("cannon_power_minus"):
		if Input.is_key_pressed(KEY_CTRL):
			muzzle_velocity = clamp(muzzle_velocity-1000, min_velocity, max_velocity)
		else:
			muzzle_velocity = clamp(muzzle_velocity-100, min_velocity, max_velocity)

		SignalBus.CannonPowerChange.emit(muzzle_velocity)


func _process(_delta):
	if GSM.gameWin != -1:
		return
	Barrel.look_at(get_global_mouse_position())
	var clampedBarrel = clamp(floor(Barrel.rotation_degrees), -75, -15)
	Barrel.rotation_degrees = clampedBarrel

	if current_rotation != clampedBarrel:
		SignalBus.CannonAngelChange.emit(clampedBarrel*-1)
		current_rotation = clampedBarrel

	if !can_shoot:
		coolDown.value += 1+_delta
		

	if coolDown.value >= coolDown.max_value:
		can_shoot = true
		coolDown.value = 0
		cooldowntimer.stop()
		cooldown_tick = cooldown
		SignalBus.FloatingText.emit("RELOADED", global_position)


func _reset_CannonPower() -> void:
	muzzle_velocity = min_velocity
	SignalBus.CannonPowerChange.emit(muzzle_velocity)


func _on_Cannon_ready():
	muzzle_velocity = floori((float)(max_velocity - min_velocity) / 2)
	SignalBus.CannonPowerChange.emit(muzzle_velocity)


func _on_MapGenerator_PlaceCannon(pos : Vector2) -> void:
	global_position = pos
	pass


func _on_cooldowntimer_timeout() -> void:
	cooldown_tick -= 1
	if cooldown_tick > 0 :
		SignalBus.FloatingText.emit(str(cooldown_tick), global_position)
