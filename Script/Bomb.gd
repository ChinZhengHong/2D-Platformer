### Bomb.gd

extends Area2D

var rotation_speed = 1

# default animation on spawn
func _ready():
	$AnimatedSprite2D.play("moving")

func _on_body_entered(body):
	# ff the bomb collides with the player, play the explosion animation and start the timer
	if body.name == "Player":
		$AnimatedSprite2D.play("explode")
		$Timer.start()
		Global.is_bomb_moving = false
	
	# Option 1
	#if the bomb collides with our level Tilemap(floor and wall)
	if body.name == "Level" and !body.name.begins_with("Platform"):
		$AnimatedSprite2D.play("explode")
		$Timer.start()
		Global.is_bomb_moving = false
	
	# Option 2
	#if the bomb collides with our wall scene, explode and remove
	if body.name.begins_with("Wall"):
		$AnimatedSprite2D.play("explode")
		$Timer.start()
		Global.is_bomb_moving = false
		
func _on_timer_timeout():
	if is_instance_valid(self):
		self.is_queued_for_deletion()
		
# rolls the bomb
func _physics_process(delta):
	# rotate the bomb if it hasn't exploded
	if Global.is_bomb_moving == true:
		$AnimatedSprite2D.rotation += rotation_speed * delta
