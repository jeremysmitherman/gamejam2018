extends Area2D

var tilemap

func _ready():
	tilemap = get_node("../../TileMap")
	connect("area_entered", self, "_on_area_entered")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_area_entered(body):
	print("HIT WALL")
	if body.is_in_group("bombs"):
		queue_free()
