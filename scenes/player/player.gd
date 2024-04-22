extends CharacterBody2D

@export var RUN_SPEED    : int = 180
@export var WALK_SPEED   : int = 100
@export var CROUCH_SPEED : int = 80
@export var JUMP_FORCE   : int = 255
@export var GRAVITY      : int = 900

@export var IS_IDLE      : bool = true
@export var IS_WALKING   : bool = false
@export var IS_RUNNING   : bool = false
@export var IS_CROUCHED  : bool = false


func _physics_process(delta):
	handle_player_movement()


func handle_player_movement():
	var direction   = Input.get_axis("move_left", "move_right")
	var is_running  = player_is_running()
	var is_crouched = player_is_crouched()
	
	if direction:
		IS_IDLE    = false
		IS_WALKING = true
		if is_crouched:
			velocity.x = direction * CROUCH_SPEED
			$AnimatedSprite2D.play("crouch_walk")
		elif is_running:
			velocity.x = direction * RUN_SPEED
			$AnimatedSprite2D.play("run")
		else:
			velocity.x = direction * WALK_SPEED
			$AnimatedSprite2D.play("walk")
	else:
		IS_WALKING = false
		IS_IDLE    = true
		velocity.x = 0
		if is_crouched: $AnimatedSprite2D.play("crouch_idle")
		else:           $AnimatedSprite2D.play("idle")
	
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

# Hold to Run
func player_is_running():
	if Input.is_action_pressed("hold_sprint"): # and is_on_floor():
		IS_CROUCHED = false
		IS_RUNNING  = true
	else:
		IS_RUNNING  = false
	return IS_RUNNING


# Toggle crouch
func player_is_crouched():
	if Input.is_action_just_pressed("toggle_crouch"): # and is_on_floor():
		IS_CROUCHED = !IS_CROUCHED
	return IS_CROUCHED
