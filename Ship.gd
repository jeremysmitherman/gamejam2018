extends Area2D

var damage = -1
var player_here = false
var player

func _ready():
	connect('body_entered', self, '_on_body_entered')
	connect('body_exited', self, '_on_body_exited')

func _physics_process(delta):
	if player_here:
		player.take_hit(self)

func _on_body_entered(body):
	if body.is_in_group('player'):
		player = body
		player_here = true
	
func _on_body_exited(body):
	if body.is_in_group('player'):
		player_here = false