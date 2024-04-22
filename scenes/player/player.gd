extends CharacterBody2D 

@export var LAST_HELD_DIRECTION    : int = 1

@export var ACCELERATION_SMOOTHING : int = 25

@export var RUN_SPEED              : int = 180
@export var WALK_SPEED             : int = 100
@export var CROUCH_SPEED           : int = 80
@export var ROLL_SPEED             : int = 200
@export var JUMP_FORCE             : int = 255
@export var GRAVITY                : int = 1100

@export var IS_IDLE                : bool = true
@export var IS_WALKING             : bool = false
@export var IS_RUNNING             : bool = false
@export var IS_JUMPING             : bool = false
@export var IS_CROUCHED            : bool = false
@export var IS_ROLLING             : bool = false
@export var IS_ATTACKING           : bool = false

func _physics_process(delta):
	var direction = get_x_movement()
	handle_player_movement(delta, direction)
	handle_player_attack()


func handle_player_movement(delta, direction):
	if direction != 0: LAST_HELD_DIRECTION = direction # Update last held direction

	var is_crouched = player_is_crouched()
	
	if IS_ATTACKING: return
	if direction:
		IS_IDLE    = false
		IS_RUNNING = true

		if is_crouched:
			velocity.x = direction * CROUCH_SPEED
			if !IS_JUMPING:
				$AnimatedSprite2D.play("crouch_walk") 
		else:
			velocity.x = direction * RUN_SPEED
			if (direction > 0 && direction < 1) or (direction < 0 && direction > -1):
				$AnimatedSprite2D.play("walk")
			else: $AnimatedSprite2D.play("run")
	else:
		IS_RUNNING = false
		IS_IDLE    = true

		velocity.x = 0
		if is_crouched: $AnimatedSprite2D.play("crouch_idle")
		else:           $AnimatedSprite2D.play("idle")
	
	# Flip player
	get_player_facing_direction(direction)
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= JUMP_FORCE

	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	move_and_slide()


func handle_player_attack():
	if !is_on_floor(): return

	if Input.is_action_just_pressed("basic_attack"):
		var animation = "sword_stab" if randf() < 0.4 else "sword_slash" 

		IS_ATTACKING = true
		$AnimatedSprite2D.play(animation)
		return
	if Input.is_action_just_pressed("heavy_attack"):
		IS_ATTACKING = true
		$AnimatedSprite2D.play("sword_heavy_attack")
		return


func get_x_movement():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return x_movement


func get_player_facing_direction(direction):
	if   direction > 0: $AnimatedSprite2D.flip_h = false
	elif direction < 0: $AnimatedSprite2D.flip_h = true


# Toggle crouch
func player_is_crouched():
	if Input.is_action_just_pressed("toggle_crouch") and is_on_floor():
		IS_CROUCHED = !IS_CROUCHED
	return IS_CROUCHED


# Press to roll
func player_is_rolling():
	if Input.is_action_just_pressed("roll") and is_on_floor():
		IS_CROUCHED = false
		IS_WALKING  = false
		IS_RUNNING  = false
		IS_ROLLING  = true
	else: IS_ROLLING = false
	return IS_ROLLING


func _on_animated_sprite_2d_animation_finished():
	IS_ATTACKING = false
