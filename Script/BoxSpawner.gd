# BoxSpawner.gd

extends Node2D

# Box Scene reference
var box = preload("res://Scene/Box.tscn")

# Reference to our scene, PathFollow2D path, AnimationPlayer path
var box_path
var box_animation

# when it's loaded into the scene\
func _ready():
	# Initiates paths
	box_path = $BoxPath/Path2D/PathFollow2D
	box_animation = $BoxPath/Path2D/AnimationPlayer
	# enable box movement on path on load
	box_animation.play("box_movement")
	# default animation on load
	$AnimatedSprite2D.play("pig_throw")
	
# shoot and spawn box onto path
func _on_timer_timeout():
	# reset animation back to idle if not throwing
	$AnimatedSprite2D.play("pig_idle")
	
	# spawn a box onto our path if there are no boxes available and can_spawn is True
	if box_path.get_child_count <= 0 and Global.can_spawn == true:
		var spawn_box = box.instantiate()
		box_path.add_child(spawn_box)
		
# Allows us to flip our pigs around in the editor
@export var flip_h = false
@export var flip_v = false

func _process(delta):
	# allows us to flip the pigs around in the editor
	$AnimatedSprite2D.flip_h = flip_h
	$AnimatedSprite2D.flip_v = flip_v
	
	# check if the boxes has reached the end of the path
	if box_path.progress_ratio >=1:
		# respawn box
		box_path.progress_ratio = 0
		Global.enable_spawning()
		box_animation.play("box_movement")
		
	# play throwing animation if path resets
	if box_path.progress_ratio ==0:
		$AnimatedSprite2D.play("pig_throw")
