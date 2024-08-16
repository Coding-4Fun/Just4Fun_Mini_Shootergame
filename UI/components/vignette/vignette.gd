extends CanvasLayer
var red : Color = Color(0.247, 0.149, 0.192)
var green : Color = Color.FOREST_GREEN

func _ready():
	SignalBus.TargetHitted.connect(on_player_damaged)
	SignalBus.GroundHit.connect(on_player_damaged)


func on_player_damaged(_score = 0):
	# if score < 0 then flash red
	# if score == 0 
	#if score > 0 then flash green
	$AnimationPlayer.play("hit")
