extends CharacterBody2D

# STATE
var held_item: Item = null

# NODES
@onready var interact_ray = $InteractRay
@onready var held_item_icon = $HeldItemIcon

# VARIABLES
const SPEED = 150.0
const JUMP_VELOCITY = -400.0
@export var lerp_amount = 0.1

func _physics_process(delta):
	# Movement
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_velocity = input_vector * SPEED
	velocity = velocity.lerp(target_velocity, lerp_amount)
	move_and_slide()
	
	# Interact raycast rotation
	if input_vector != Vector2.ZERO:
		interact_ray.target_position = input_vector * 40.0 # Adjust reach distance
		
	# INTERACTION INPUT
	if Input.is_action_just_pressed("interact"): # Spacebar
		_attempt_interact()
		
	if Input.is_action_just_pressed("drop"): # D
		drop_item()

func _attempt_interact():
	if interact_ray.is_colliding():
		var object = interact_ray.get_collider()
		if object.has_method("interact"):
			object.interact(self)

# --- PUBLIC FUNCTIONS (Called by other objects) ---

func pickup(item_resource: Resource):
	held_item = item_resource
	print("Picked up: ", held_item.resource_path) # Debugging helpful for resources
	update_visuals()

func drop_item():
	held_item = null
	update_visuals()

func update_visuals():
	if held_item == null:
		held_item_icon.visible = false
	else:
		held_item_icon.visible = true
		held_item_icon.texture = held_item.texture
