extends Node2D

export var left:bool = true

export var muzzle_velocity = 1500
export var min_velocity = 10000
export var max_velocity = 60000
export var gravity = 250

var can_shoot = true
var current_rotation = 0

onready var Muzzle = get_node("Barrel/Muzzle")
onready var Barrel = get_node("Barrel")
onready var Main = get_tree().get_root().get_node("MainGame")


func _ready():
	if !SignalBus.is_connected("CannonShoot", Preloads.UIMain, "_on_Cannon_Shot"):
		assert(SignalBus.connect("CannonShoot", Preloads.UIMain, "_on_Cannon_Shot")==OK)

	## Kannonen umdrehen, wenn auf der rechten Seite


func _unhandled_input(event):
	if event.is_action_released("cannon_shoot") and can_shoot:
		var b = Preloads.Bullet.instance()
		Main.add_child(b)
		b.Ply = name
		b.add_to_group("Shoots")
		b.transform = Muzzle.global_transform
		b.velocity = b.transform.x * muzzle_velocity
		b.g = gravity
		SignalBus.emit_signal("CannonShoot")
	if event.is_action_released("cannon_power_plus"):
		muzzle_velocity = clamp(muzzle_velocity+100, min_velocity, max_velocity)
		SignalBus.emit_signal("CannonPowerChange", muzzle_velocity)
	if event.is_action_released("cannon_power_minus"):
		muzzle_velocity = clamp(muzzle_velocity-100, min_velocity, max_velocity)
		SignalBus.emit_signal("CannonPowerChange", muzzle_velocity)
#		can_shoot = false


func _process(_delta):
	Barrel.look_at(get_global_mouse_position())
	var clampedBarrel = clamp(floor(Barrel.rotation_degrees), -75, -15)
	Barrel.rotation_degrees = clampedBarrel

	if can_shoot:
		if current_rotation != clampedBarrel:
			SignalBus.emit_signal("CannonAngelChange", clampedBarrel*-1)
			current_rotation = clampedBarrel


func _reset_CannonPower() -> void:
	muzzle_velocity = min_velocity
	SignalBus.emit_signal("CannonPowerChange", muzzle_velocity)
