extends CharacterBody2D

# STATE
var held_item: String = "" # Empty string = holding nothing

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

func pickup(item_name: String):
	held_item = item_name
	print("Player picked up: ", held_item)
	update_visuals()

func drop_item():
	held_item = ""
	print("Player dropped item")
	update_visuals()

func update_visuals():
	if held_item == "":
		held_item_icon.visible = false
	else:
		held_item_icon.visible = true
		# Replace with icons eventually
		held_item_icon.modulate = Color.RED 
		
		## Use this method to change items based on the item name
		# held_item_icon.texture = load("res://assets/items/" + held_item + ".png")
