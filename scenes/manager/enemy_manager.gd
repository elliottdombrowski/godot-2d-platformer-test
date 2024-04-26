extends Node

const SPAWN_RADIUS = 1000

@export var stone_golem_scene : PackedScene

@onready var timer            : Timer = $Timer

func _ready():
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return
	
	# TODO - make this spawn on a 2d plane checking for ground
	var random_direction_x = randf_range(-1, 1)
	var spawn_position_x = player.global_position.x + (random_direction_x * SPAWN_RADIUS) 
	var spawn_position = Vector2(spawn_position_x, 500)
	
	var stone_golem = stone_golem_scene.instantiate() as Node2D
	get_parent().add_child(stone_golem)
	stone_golem.global_position = spawn_position
