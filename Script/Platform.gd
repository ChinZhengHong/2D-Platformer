### Platform.gd
extends Area2D

# platform movement states
enum State {WAIT_AT_BOTTOM, MOVING_UP, WAIT_AT_TOP, MOVING_DOWN}

# capture current state of platform
var current_state = State.WAIT_AT_BOTTOM

# movement position and movement progress value
var initial_position
var progress = 0.0

#  platform movement speed and range
@export var movement_speed = 50.0
@export var movement_range = 50

# wait times
@export var wait_time_at_top = 3.0 # Time in second to wait at top
@export var wait_time_at_bottom = 3.0 # Time in second to wait at bottom

func _on_timer_timeout():
	if current_state == State.WAIT_AT_TOP:
		switch_state(State.MOVING_DOWN)
	
	if current_state == State.WAIT_AT_BOTTOM:
		switch_state(State.MOVING_UP)
		
# sets platforms y position on game start and switches the state
func _ready():
	initial_position = position.y
	switch_state(State.MOVING_UP)
