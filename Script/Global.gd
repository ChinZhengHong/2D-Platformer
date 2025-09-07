### Global.gd
extends Node

# movement state
var is_attacking = false
var is_climbing = false
var is_jumping = false

# Indicates if box can be spawn
var can_spawn = true

# current scene
var current_scene_name

# bomb movement state
var is_bomb_moving = false

func _ready():
	# sets the current scene's name
	current_scene_name = get_tree().get_current_scene().name

# function to disable box spawning
func disable_spawning():
	can_spawn = false
	
# function to enable box spawning
func enable_spawning():
	can_spawn = true
