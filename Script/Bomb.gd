### Bomb.gd

extends Area2D

# default animation on spawn
func _ready():
	$AnimatedSprite2D.play("moving")

func _on_body_entered(body):
	# ff the bomb collides with the player, play the explosion animation and start the timer
	if body.name == "Player":
		$AnimatedSprite2D.play("explode")
		$Timer.start()
		
	#if the bomb collides with our level Tilemap(floor and wall)
	if body.name.begins_with("Wall"):
		$AnimatedSprite2D.play("explode")
		$Timer.start()
		
func _on_timer_timeout():
	if is_instance_valid(self):
		self.queue_free()
