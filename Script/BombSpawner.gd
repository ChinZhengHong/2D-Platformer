### BombSpawner.gd

extends Node2D

#bomb scene reference
var bomb = preload("res://Scene/Bomb.tscn")

# reference to our scene, PathFollow2D path, and AnimationPlayer path
var current_scene_path
var bomb_path
var bomb_animation

# when it's loaded into the scene
func _ready():
	# default animation load
	$AnimatedSprite2D.play("cannon_idle")
	# initiates paths
	current_scene_path = "/root/" + Global.current_scene_name + "/" #current scene\
	bomb_path = get_node(current_scene_path + "/BombPath/Path2D/PathFollow2D") # PathFollow2D
	bomb_animation = get_node(current_scene_path + "/BombPath/Path2D/AnimationPlayer") # Animation Player
	# start bomb movement
	bomb_animation.play("bomb_movement")
	
# spawn bomb instance
func shoot():
	# play cannon shoot animation each time the function is fired off
	$AnimatedSprite2D.play("cannon_fired")
	# set the bomb to move and play the animation
	Global.is_bomb_moving = true
	bomb_animation.play("bomb_movement")
	# returned spawned bomb
	var spawned_bomb = bomb.instantiate()
	return spawned_bomb

# shoot and spawn bomb at path
func _on_timer_timeout():
	# reset animation before shooting
	$AnimatedSprite2D.play("cannon_idle")
	# spawn a bomb onto our path if there are no bombs available
	if bomb_path.get_child_count() <= 0:
		bomb_path.add_child(shoot())
	# clear all existing bomb
	if Global.is_bomb_moving == false:
		for bombs in bomb_path.get_children():
			bomb_path.remove_child(bombs)
			bomb.is_queued_for_deletion()
			bomb_animation.stop()
