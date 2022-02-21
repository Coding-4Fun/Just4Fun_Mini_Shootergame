extends Camera2D

var cam_speed = 10

func _ready() -> void:
	set_process(true)
	pass


func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		translate(Vector2(0, -cam_speed))
	if Input.is_action_pressed("ui_down"):
		translate(Vector2(0, cam_speed))
	if Input.is_action_pressed("ui_left"):
		translate(Vector2(-cam_speed, 0))
	if Input.is_action_pressed("ui_right"):
		translate(Vector2(cam_speed, -0))
