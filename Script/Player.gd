##Player.gd

extends CharacterBody2D

# custom signals
signal update_lives(lives,max_lives)
signal update_attack_boost(attack_time_left)

#health stats
var max_lives = 3
var lives = 3

# player movement variables
@export var speed = 200
@export var gravity = 200
@export var jump_height = -150

# Keep track last direction ( 1 for right and -1 for left, 0 for none)
var last_direction = 0
# check direction of the player's movement
var current_direction = 0

# seconds allowed to attack
var attack_time_left = 0 

# movement and physics
func _physics_process(delta):
	# vertical movement velocity(down)
	velocity.y += gravity * delta * 2
	# horizontal movement processing (left, right)
	horizontal_movement()
	# applies movement
	move_and_slide()
	#applied animation
	if !Global.is_attacking and !Global.is_climbing:
		player_animation()

func horizontal_movement():
	# if keys are pressed it will return 1 for ui_right, -1 for ui_left, and 0 for neither
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# horizontal velocity which moves player left or right based on input
	velocity.x = horizontal_input * speed

# animation
func player_animation():
	# on left (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_left") && Global.is_jumping == false:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = 7
	
	# on right (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_right") && Global.is_jumping == false:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = -7
		
	# on idle if nothing is being pressed
	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle")
		
# singular input captures
func _input(event):
	# on attacking
	if event.is_action_just_pressed("ui_attack"):
		if Global.is_attacking == true:
			$AnimatedSprite2D.play("attack")
		
	# on jump
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		$AnimatedSprite2D.play("jump")
		
	# on climbing ladders
	if Global.is_climbing == true:
		if !Input.is_anything_pressed():
			$AnimatedSprite2D.play("idle")
			
		if Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play("climb")
			gravity = 100
			velocity.y = -200
			
	# reset gravity
	else:
		gravity = 200
		Global.is_climbing = false
		Global.is_jumping = false


func _on_animated_sprite_2d_animation_finished():
	if attack_time_left <= 0:
		Global.is_attacking = false
	set_physics_process(true)
	Global.is_climbing = false
	
func _ready():
	current_direction = -1
	
	# set our attack timer to be the value of our wait time
	attack_time_left = $AttackBoostTimer.wait_time
	
	# updates our UI labels when signals are emitted
	update_lives.connect($UI/Health.update_lives)
	
	# show our correct lives value on load
	$UI/Health/Label.text = str(lives)
	
func _process(_delta):
	if velocity.x > 0: # Moving right
		current_direction = 1
	if velocity.x < 0: # Moving left
		current_direction = -1
		
	# If the firection has changed, play the approriate animation
	if current_direction != last_direction:
		if current_direction == 1:
			# limits
			$Camera2D.limit_left = -110
			$Camera2D.limit_bottom = 705
			$Camera2D.limit_top = 40
			$Camera2D.limit_right = 1068
			
			# Play the right animation
			$AnimationPlayer.play("move_right")
		
		elif current_direction == -1:
			# limits
			$Camera2D.limit_left = 90
			$Camera2D.limit_bottom = 705
			$Camera2D.limit_top = 40
			$Camera2D.limit_right = 1268
			
			# Play the left animation
			$AnimationPlayer.play("move_left")
			
		last_direction = current_direction

# takes damage
func take_damage():
	# deduct and update lives
	if lives > 0:
		lives = lives - 1
		update_lives.emit(lives,max_lives)
		print(lives)
		# play damage animation
		$AnimatedSprite2D.play("damage")
		# allows animation to play'
		set_physics_process(false)
		
# add to pickups to our player and updates our lives / attack boosts
func add_pickup(pickup):
	# increases life count if we don't have 3 lives already
	if pickup == Global.Pickups.HEALTH:
		if lives < max_lives:
			lives += 1
			update_lives.emit(lives,max_lives)
			print(lives)
	
	# temporary allow us to destroy boxes/bombs
	if pickup == Global.Pickups.ATTACK:
		Global.is_attacking = true
		
	# increase our player's score
	if pickup == Global.Pickups.SCORE:
		pass


func _on_attack_boost_timer_timeout():
	# set attack back to false if the time on boost runs out
	if attack_time_left <= 0:
		Global.is_attacking = false
