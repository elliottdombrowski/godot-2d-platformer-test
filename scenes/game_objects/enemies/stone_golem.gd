extends CharacterBody2D

const MAX_SPEED          : int  = 40
const ATTACK_RANGE       : int  = 60
@export var IS_DEAD      : bool = false
@export var IS_DAMAGED   : bool = false
@export var IS_ATTACKING : bool = false
@export var GRAVITY      : int  = 900

@onready var health_component : HealthComponent  = $HealthComponent
@onready var animation        : AnimatedSprite2D = $AnimatedSprite2D
@onready var collision        : CollisionShape2D = $CollisionShape2D


func _ready():
	health_component.died.connect(on_died)
	health_component.damaged.connect(on_damaged)


func _physics_process(delta):
	if IS_DEAD:    return
	if IS_DAMAGED: return

	var direction          = get_direction_x_to_player()
	var distance_to_player = get_distance_x_to_player()
	get_enemy_facing_direction(direction.x)
	
	if distance_to_player <= ATTACK_RANGE:
		IS_ATTACKING = true
		velocity.x = 0
		animation.play("smash")

	if IS_ATTACKING: return
	if (direction.x > 0) or (direction.x < 0):
		animation.play("walk")
	else: animation.play("idle")

	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	velocity.x = direction.x * MAX_SPEED
	move_and_slide()


func get_direction_x_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node == null: return Vector2.ZERO # Return if player is null
	return (player_node.global_position - global_position).normalized()


func get_distance_x_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node == null: return ATTACK_RANGE
	return abs(global_position.x - player_node.global_position.x)


func get_enemy_facing_direction(direction):
	if   direction > 0: animation.flip_h = true
	elif direction < 0: animation.flip_h = false


func on_damaged():
	IS_DAMAGED = true
	velocity.x = 0
	animation.play("hurt")


func on_died():
	IS_DEAD = true
	velocity.x = 0
	collision.disabled = true
	animation.play("death")


func _on_animated_sprite_2d_animation_finished():
	IS_ATTACKING = false
	IS_DAMAGED   = false
	if IS_DEAD: queue_free()
