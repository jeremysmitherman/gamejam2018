extends Node

var mob
var animation
var gravity = 20
var speed = 100
var jump_frames = 10
var jump_speed = 120
var cur_jump_frames = 0
var is_jumping = false
var is_stationary_firing = false
var stationary_firing_frames = 0
var stationary_firing_frames_max = 70

var fire_delay_frames = 20
var cur_fire_delay_frames = 0

var velocity = Vector2()
var inputs = Vector2()
var bullet = load("res://Man/bullet.tscn")

func _ready():
	mob = get_owner()
	animation = get_node('../AnimatedSprite')

func _process(delta):
	cur_fire_delay_frames += 1
	inputs.x = 0
	inputs.y = 0
	if Input.is_action_pressed("ui_right"):
		inputs.x += speed
	if Input.is_action_pressed("ui_left"):
		inputs.x -= speed
	
	if Input.is_action_just_pressed("jump") and mob.is_on_floor():
		is_jumping = true
		cur_jump_frames = 0
	
	if is_jumping and !Input.is_action_pressed("jump"):
		is_jumping = false
	elif is_jumping and Input.is_action_pressed("jump"):
		cur_jump_frames += 1
		if cur_jump_frames > jump_frames:
			is_jumping = false
	
	if Input.is_action_just_pressed("fire") and cur_fire_delay_frames > fire_delay_frames:
		cur_fire_delay_frames = 0
		if inputs.x == 0 and mob.is_on_floor():
			stationary_firing_frames = 0
			is_stationary_firing = true
			animation.play("fire")
		var bullet_instance = bullet.instance()
		bullet_instance.global_position = mob.global_position
		bullet_instance.global_position.y -= 3
		if animation.flip_h:
			bullet_instance.global_position.x = mob.global_position.x - 10
			bullet_instance.direction = -1
		else:
			bullet_instance.global_position.x = mob.global_position.x + 10	
		add_child(bullet_instance)
	
	if inputs.x != 0:
		animation.play("run")
		is_stationary_firing = false
	elif is_stationary_firing and stationary_firing_frames < stationary_firing_frames_max:
		stationary_firing_frames += 1
	else:
		animation.play("default")

	if inputs.x < 0:
		animation.set_flip_h(true)
	if inputs.x > 0:
		animation.set_flip_h(false)
	if !mob.is_on_floor():
		if velocity.y > 40:
			animation.play("fall")
		else:
			animation.play("jump")

func _physics_process(delta):
	velocity.x = 0
	if is_jumping:
		velocity.y -= jump_speed - cur_jump_frames * 5
	velocity.y += gravity
	velocity.y = clamp(velocity.y, -200, 250)
	
	velocity.x = inputs.x
	velocity = mob.move_and_slide(velocity, Vector2(0, -1))
