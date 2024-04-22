extends Camera2D

var target_position = Vector2.ZERO

func _ready():
	make_current()

func _process(delta):
	get_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20))


func get_target():
	# Get player's current position
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return
	target_position = player.global_position