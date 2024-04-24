extends CharacterBody2D

@export var GRAVITY : int = 900

func _ready():
	pass


func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	move_and_slide()
