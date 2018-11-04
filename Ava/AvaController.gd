extends Node

var hp = 10
var mob
var explosion = load("res://Effects/Explosion.tscn")

func _ready():
	get_owner().add_to_group('enemies')
	mob = get_owner()
	mob.connect("hit_taken", self, "take_hit")

func _process(delta):
	if hp <= 0:
		var expl = explosion.instance()
		expl.global_position = mob.global_position
		get_tree().get_root().add_child(expl)
		get_owner().queue_free()

func take_hit(initiator):
	print("Hit in Ava")
	hp -= initiator.damage
