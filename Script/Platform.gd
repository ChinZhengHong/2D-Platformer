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

# change the platforms movement states
func switch_state(new_state):
	current_state = new_state
	match new_state:
		# if state is moving up, reset progress
		State.MOVING_UP:
			progress = 0.0
			
		# if state is waiting at top, start the timer to change the state
		State.WAIT_AT_TOP:
			$Timer.wait_time = wait_time_at_top # will wait x second before moving
			$Timer.start()
			
		#if state is waiting at bottom, start the timer to change the state
		State.WAIT_AT_BOTTOM:
			$Timer.wait_time = wait_time_at_bottom # will wait x second before moving
			$Timer.start()
			
		# if state is moving down, move the platfoprm via the speed and range defined
		State.MOVING_DOWN:
			progress = movement_range / movement_speed
			
# move our platform
func _physics_process(delta):
	match current_state:
		# if its moving up
		State.MOVING_UP:
			progress += delta
			#change its position
			position.y = lerp(initial_position, initial_position - movement_range, progress / (movement_range / movement_range))
			if progress >= (movement_range / movement_speed):
				switch_state(State.WAIT_AT_TOP)
				
		# if its moving down
		State.MOVING_DOWN:
			progress -= delta
			# change its position	
			position.y = lerp(initial_position, initial_position - movement_range, progress / (movement_range / movement_speed))
			if progress <= 0:
				switch_state(State.WAIT_AT_BOTTOM)
