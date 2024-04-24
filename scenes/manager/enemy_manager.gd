extends Node

const SPAWN_RADIUS = 375

@export var stone_golem_scene : PackedScene

@onready var timer            : Timer = $Timer

func _ready():
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
	
	var stone_golem = stone_golem_scene.instantiate() as Node2D
	get_parent().add_child(stone_golem)
	stone_golem.global_position = spawn_position
