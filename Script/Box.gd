# Box.gd

extends Area2D

# Default animation on spawn
func _ready():
	$AnimatedSprite2D.play("moving")
	
func _on_body_entered(body):
	# if the box collides with the player, play the explosion animation and disable spawning
	if body.name == "Player":
		$AnimatedSprite2D.play("explode")
		# Disable spawning in BoxSpawner
		Global.disable_spawning()
		# deal damage
		body.take_damage()

	# if the box collides with the wall , remove so that it can respawn
	if body.name.begins_with("Wall") or body.name == "Level":
		queue_free()

# if the box explosion animation is playing, remove it from the scene
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "explode":
		queue_free()
