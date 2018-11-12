extends CanvasLayer

var life_display = 100
var life = 100
var texture_progress
var player

func _ready():
	texture_progress = get_node("TextureProgress")

func _process(delta):
	if not player:
		var players = get_tree().get_nodes_in_group("player")
		if players:
			player = players[0]
			player.get_node("PlayerController").connect("stats_changed", self, "_on_stats_change")
	
	
	texture_progress.value = life_display

func _physics_process(delta):
	if life_display > life:
		life_display -= 2
	elif life_display < life:
		life_display += 2

func _on_stats_change(amount):
	life -= amount
