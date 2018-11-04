extends Area2D

var direction = 1
var velocity = Vector2()
var speed = 16000
var sprite
var flash = false
var cur_flash_frames = 0

func _ready():
	sprite = get_node('./Sprite')
	if direction == -1:
		sprite.flip_h = true
		

func _process(delta):
	if cur_flash_frames > 1:
		flash = !flash
		cur_flash_frames = 0
	else:
		cur_flash_frames += 1
		
	if not flash:
		sprite.modulate = Color(1, 1, 1, 1)
	else:
		sprite.modulate = Color(1, 1, 1, .7)
		

func _physics_process(delta):
	velocity.x = speed * direction * delta
	position += velocity * delta
	