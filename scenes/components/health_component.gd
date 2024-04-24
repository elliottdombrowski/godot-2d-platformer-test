extends Node
class_name HealthComponent

signal died
signal damaged

@export var max_health : float = 10
var current_health


func _ready():
	current_health = max_health


func damage(damage_amount: float):
	# Make sure current_health is never negative
	current_health = max((current_health - damage_amount), 0)
	Callable(check_damaged).call_deferred() # Call check_damaged on next idle frame
	Callable(check_death).call_deferred()   # Call check_death on next idle frame


func check_damaged():
	if current_health > 0:
		damaged.emit()


func check_death():
	if current_health == 0:
		# Owner is freed from queue on case-by-case basis
		# after death animation has finished.
		# Example - see stone_golem scene.
		died.emit()
