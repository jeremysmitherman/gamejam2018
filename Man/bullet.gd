extends KinematicBody2D

var direction = 1
var speed = 300
var velocity = Vector2()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	velocity.x = speed * direction * delta
	move_and_collide(velocity)
