extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0
@export var lerp_amount = 0.1


func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_velocity = input_vector * SPEED
	velocity = velocity.lerp(target_velocity, lerp_amount)
	move_and_slide()
