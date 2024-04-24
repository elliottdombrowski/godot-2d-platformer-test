extends CharacterBody2D 

@export var LAST_HELD_DIRECTION    : int = 1

@export var ACCELERATION_SMOOTHING : int = 25

@export var RUN_SPEED              : int = 180
@export var WALK_SPEED             : int = 100
@export var CROUCH_SPEED           : int = 80
@export var ROLL_SPEED             : int = 200
@export var JUMP_FORCE             : int = 300
@export var GRAVITY                : int = 900

@export var IS_IDLE                : bool = true
@export var IS_WALKING             : bool = false
@export var IS_RUNNING             : bool = false
@export var IS_JUMPING             : bool = false
@export var CAN_DOUBLE_JUMP        : bool = false
@export var IS_CROUCHED            : bool = false
@export var IS_ROLLING             : bool = false
@export var IS_ATTACKING           : bool = false

@onready var animation             : AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox                                   = $HitboxComponent/CollisionShape2D

func _physics_process(delta):
	var direction = get_x_movement()
	get_player_facing_direction(direction)
	handle_player_movement(delta, direction)
	handle_player_attack()
	hitbox.disabled = !IS_ATTACKING


func handle_player_movement(delta, direction):
	if direction != 0: LAST_HELD_DIRECTION = direction # Update last held direction

	var is_crouched : bool = player_is_crouched()
	var is_grounded : bool = player_is_grounded()

	if IS_ATTACKING: return
	if direction:
		IS_IDLE    = false
		IS_RUNNING = true

		if is_crouched:
			velocity.x = direction * CROUCH_SPEED
			play_animation("crouch_walk")
		else:
			velocity.x = direction * RUN_SPEED
			if (direction > 0 && direction < 1) or (direction < 0 && direction > -1):
				play_animation("walk")
			else: play_animation("run")
	else:
		IS_RUNNING = false
		IS_IDLE    = true

		velocity.x = 0
		if is_crouched: play_animation("crouch_idle")
		else:           play_animation("idle")
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y -= JUMP_FORCE
			CAN_DOUBLE_JUMP = true
			play_animation("jump")
		if !is_on_floor() and CAN_DOUBLE_JUMP and Input.is_action_just_pressed("jump"):
			velocity.y -= JUMP_FORCE
			CAN_DOUBLE_JUMP = false
			play_animation("double_jump")

	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	move_and_slide()


func handle_player_attack():
	if !is_on_floor(): return

	if Input.is_action_just_pressed("basic_attack"):
		var attack = "sword_stab" if randf() < 0.4 else "sword_slash" 
		IS_ATTACKING = true
		animation.play(attack)

	if Input.is_action_just_pressed("heavy_attack"):
		IS_ATTACKING = true
		animation.play("sword_heavy_attack")


func get_x_movement():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return x_movement


func get_player_facing_direction(direction):
	if direction > 0: 
		animation.flip_h = false
		hitbox.position.x = 18
	elif direction < 0:
		hitbox.position.x = -18
		animation.flip_h = true


# Toggle crouch
func player_is_crouched():
	if Input.is_action_just_pressed("toggle_crouch") and is_on_floor():
		IS_CROUCHED = !IS_CROUCHED
	return IS_CROUCHED


func player_is_grounded():
	IS_JUMPING = !is_on_floor()
	return IS_JUMPING


func play_animation(anim_str):
	match anim_str:
		"jump":            animation.play(anim_str)
		"double_jump":     animation.play(anim_str)
		_: if !IS_JUMPING: animation.play(anim_str)


func _on_animated_sprite_2d_animation_finished():
	IS_ATTACKING = false
