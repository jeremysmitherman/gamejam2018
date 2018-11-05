extends Node

var hp = 10
var mob
var explosion = load("res://Effects/Explosion.tscn")
var beam = load("res://Ava/Beam.tscn")
var iframes = 6
var cur_iframes = 6
var flash = false
var target

var animation
onready var sprite = get_node("../AnimatedSprite")
onready var attack_timer = get_node("../AttackTimer")
onready var patrol_timer = get_node("../PatrolTimer")

var velocity = Vector2()
var patrol_direction = 1
var patrol_speed = 10
var is_patrolling = true
var can_attack = true
var can_patrol = true

func _ready():
	get_owner().add_to_group('enemies')
	mob = get_owner()
	mob.connect("hit_taken", self, "take_hit")
	animation = get_node("../AnimationPlayer")
	attack_timer.connect("timeout", self, "_on_attack_timer_timeout")
	patrol_timer.connect("timeout", self, "_on_patrol_timer_timeout")
	attack_timer.set_wait_time(2)
	patrol_timer.set_wait_time(3)
	patrol_timer.start()

func _process(delta):
	if not target:
		var targets = get_tree().get_nodes_in_group("player")
		if not targets.empty():
			target = targets[0]
		
	if target.global_position.x < mob.global_position.x:
		sprite.set_flip_h(true)
	else:
		sprite.set_flip_h(false)

	if can_attack and abs(mob.global_position.y - target.global_position.y) < 20:
		can_attack = false
		animation.play("Fire")

	if cur_iframes < iframes:
		if flash == false:
			sprite.modulate = Color(10, 10, 10, .2)
			flash = true
		else:
			flash = false
			sprite.modulate = Color(1, 1, 1, 1)
		cur_iframes += 1
	else:
		sprite.modulate = Color(1, 1, 1, 1)
	if hp <= 0:
		var expl = explosion.instance()
		expl.global_position = mob.global_position
		get_tree().get_root().add_child(expl)
		get_owner().queue_free()

func _physics_process(delta):
	if is_patrolling:
		velocity.y += 20
		velocity.x = patrol_speed *  patrol_direction
		velocity = mob.move_and_slide(velocity, Vector2(0, -1))

func take_hit(initiator):
	cur_iframes = 0
	hp -= initiator.damage

func _on_attack_timer_timeout():
	can_attack = true

func _on_patrol_timer_timeout():
	is_patrolling = !is_patrolling
	patrol_direction = 1
	if randf() < 0.5:
    	patrol_direction = -1

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fire":
		attack_timer.start()

func fire_beam():
	var beam_instance = beam.instance()
	if sprite.flip_h:
		beam_instance.direction = -1
		beam_instance.rotation = 0
	var pos = mob.global_position
	pos.x += 20 * beam_instance.direction
	beam_instance.global_position = pos
	get_tree().get_root().add_child(beam_instance)
