extends Node

# Reference to the parent kinematic body, set in _ready
var mob

# Reference to the animated sprite node, set in _ready
var animation

# Gravity constant, number of units per physics frame the player will return to earth if not jumping
var gravity = 20

# Horizontal movement speed
var speed = 100

# Maximum jump of frames player can hold the jump button before is_jumping is set to false automatically.
# Increase this to have longer jumps
var jump_frames = 10

# Initial impulse speed when jumping.  This is decreased by a constant to give a smooth deceleration over the course
# of a jump.  Increase this to have faster, more powerful jumps.
var jump_speed = 120

# Number of frames we've been jumping.
var cur_jump_frames = 0

# Tells the physics engine to increase our vertical speed
var is_jumping = false

# Used to cue a different animation if we're firing, but not moving or jumping.
var is_stationary_firing = false

# How long we've been in and how many frames we'll stay in the stationary firing animation
var stationary_firing_frames = 0
var stationary_firing_frames_max = 120

# How many frames must pass before we can fire again, and how many frames it's been since we've fired.
var fire_delay_frames = 24
var cur_fire_delay_frames = 0

# Overall velocity of the character
var velocity = Vector2()

# Player inputs for X movement
var inputs = Vector2()

# Reference to the bullet scene so we can instanciate bullets when firing.
var bullet = load("res://Man/bullet.tscn")

func _ready():
	mob = get_owner()
	animation = get_node('../AnimatedSprite')
	get_owner().add_to_group('player')

func _process(delta):
	inputs.x = 0
	inputs.y = 0
	if Input.is_action_pressed("ui_right"):
		inputs.x += speed
	if Input.is_action_pressed("ui_left"):
		inputs.x -= speed

	# Flip the sprite based on the direction we're moving
	if inputs.x < 0:
		animation.set_flip_h(true)
	if inputs.x > 0:
		animation.set_flip_h(false)
		
	# If we aren't on the floor, play the appropriate animation for our vertical speed
	if !mob.is_on_floor():
		if velocity.y > 40:
			animation.play("fall")
		else:
			animation.play("jump")

func _physics_process(delta):
	# Increment fire delay and get inputs
	cur_fire_delay_frames += 1
	
	# Set is_jumping if we pressed jump this frame and we're on the floor
	# Reset jumping frames
	if Input.is_action_just_pressed("jump") and mob.is_on_floor():
		is_jumping = true
		cur_jump_frames = 0
	
	# Check to make sure we're still pressing jumping, if not set is_jumping false.
	# If we are, see if we're at the frame limit we're allowing a jump
	if is_jumping and !Input.is_action_pressed("jump"):
		is_jumping = false
	elif is_jumping and Input.is_action_pressed("jump"):
		cur_jump_frames += 1
		if cur_jump_frames > jump_frames:
			is_jumping = false
	
	# Fire a bullet if we've waited enough frames and we're pressing the fire button.
	# If we're on the floor and not moving, fire the stationary firing animation and reset the
	# variables that control how long that lasts.
	if Input.is_action_just_pressed("fire") and cur_fire_delay_frames > fire_delay_frames:
		cur_fire_delay_frames = 0
		if inputs.x == 0 and mob.is_on_floor():
			stationary_firing_frames = 0
			is_stationary_firing = true
			animation.play("fire")
		
		# Instanciate a bullet, then set it's position based on our facing, if
		# we're facing left set the direction property of the bullet instance to -1 so 
		# it flies the correct direction
		var bullet_instance = bullet.instance()
		bullet_instance.global_position = mob.global_position
		bullet_instance.global_position.y -= 3
		if animation.flip_h:
			bullet_instance.global_position.x = mob.global_position.x - 10
			bullet_instance.direction = -1
		else:
			bullet_instance.global_position.x = mob.global_position.x + 10	
		add_child(bullet_instance)
	
	# If we're running, play that animation and override the stationary firing animation
	# If we're in the stationary firing animation, not moving, and we're under the maximum time
	# for that animation, increment the stationary firing frames.  If the stationary firing frames 
	# are over the limit, set the animation back to idle.
	if inputs.x != 0:
		animation.play("run")
		is_stationary_firing = false
	elif is_stationary_firing and stationary_firing_frames < stationary_firing_frames_max:
		stationary_firing_frames += 1
	else:
		animation.play("default")
	
	velocity.x = 0
	# If we're jumping, increase our vertical speed (negative y) based on a decaying value so we get a nice burst 
	# at the start of the jump that decays until we hit jump_frames, where is_jumping will be forcibly set to false, 
	# and nothing will oppose gravity, bringing our gent back to earth.
	if is_jumping:
		velocity.y -= jump_speed - cur_jump_frames * 5
	velocity.y += gravity
	velocity.y = clamp(velocity.y, -200, 250)
	
	velocity.x = inputs.x
	velocity = mob.move_and_slide(velocity, Vector2(0, -1))
