# CannonHandler.gd

extends Node2D

# speech bublle randomize time
var rng = RandomNumberGenerator.new()

# when it's loaded into scene
func _ready():
	# play cannon lightning animation on start
	$Body.play("matching")
	
func  _process(_delta):
	# randomizes speech bubble randomize time
	$Timer.wait_time = randi_range(1, 10)
	
	# idle animation
	if Global.is_bomb_moving == true:
		$Body.play("idle")
		# show speech bubble
		$SpeechBubble.visible = true
		
	# matching animation
	if Global.is_bomb_moving == false:
		$Body.play("matching")
		# hide speech bubble
		$SpeechBubble.visible = false

func _on_timer_timeout():
	# randomizes speech
	var random_speech = randi() % 3 # will return 0, 1, 2
	match random_speech:
		0: 
			$SpeechBubble.play("boom")
		1:
			$SpeechBubble.play("loser")
		2: 
			$SpeechBubble.play("swearing")
