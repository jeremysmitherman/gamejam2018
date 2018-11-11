extends Camera2D

var target

func _ready():
	pass

func _process(delta):
	if not target:
		var targets = get_tree().get_nodes_in_group("player")
		if targets:
			target = targets[0]
	else:
		global_position = target.global_position