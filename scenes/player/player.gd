extends CharacterBody2D

@export var SPEED      : int = 155
@export var JUMP_FORCE : int = 255
@export var GRAVITY    : int = 900


func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
	else:
		velocity.x = 0
		$AnimatedSprite2D.play("idle")
	
	# Flip player
	get_player_facing_direction(direction)
	
	# Jump
	# NOTE - Need gravity 
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y -= JUMP_FORCE

	# Gravity
	#if not is_on_floor():
		#velocity.y += GRAVITY * delta
	
	move_and_slide()


func get_player_facing_direction(direction):
	if   direction ==  1: $AnimatedSprite2D.flip_h = false
	elif direction == -1: $AnimatedSprite2D.flip_h = true
