extends Area2D

var direction = 1
var damage = 40
var velocity = Vector2()
var speed = 16000
var sprite
var flash = false
var timer
var cur_flash_frames = 0

func _ready():
	connect('body_entered', self, '_on_body_entered')
	timer = get_node("./Timer")
	sprite = get_node('./Sprite')
	timer.connect("timeout", self, "_kill")
	timer.set_wait_time(4)
	timer.start()
	if direction == -1:
		sprite.flip_h = true
		

func _process(delta):
    pass
	
func _on_body_entered(body):
	if body.is_in_group('player'):
		body.take_hit(self)
	queue_free()

func _physics_process(delta):
	velocity.x = speed * direction * delta
	position += velocity * delta
	
	if cur_flash_frames > 1:
		flash = !flash
		cur_flash_frames = 0
	else:
		cur_flash_frames += 1
		
	if not flash:
		sprite.modulate = Color(1, 1, 1, 1)
	else:
		sprite.modulate = Color(1, 1, 1, .7)

func _kill():
	queue_free()