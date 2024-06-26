extends Camera2D

const NUDGE_OFF_BOTTOM = 80

var target_position = Vector2.ZERO

func _ready():
	offset.y -= NUDGE_OFF_BOTTOM
	make_current()

func _process(delta):
	get_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 15))


func get_target():
	# Get player's current position
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return
	target_position = player.global_position
