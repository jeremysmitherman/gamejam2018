extends Area2D

var direction = 1
var damage = 5
var speed = 30000
var velocity = Vector2()

func _ready():
	connect('body_entered', self, '_on_body_entered')

func _physics_process(delta):
	velocity.x = speed * direction * delta
	position += velocity * delta
	
func _on_body_entered(body):
	if body.is_in_group('enemies'):
		body.take_hit(self)
	queue_free()
