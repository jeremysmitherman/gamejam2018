extends Area2D

var damage = -30

func _ready():
	connect('body_entered', self, '_on_body_entered')

func _on_body_entered(body):
	if body.is_in_group('player'):
		body.take_hit(self)
		queue_free()
