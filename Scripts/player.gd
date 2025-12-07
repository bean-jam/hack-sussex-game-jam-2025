extends CharacterBody2D

# STATE
var held_item: Item = null

# NODES
@onready var interact_ray = $InteractRay
@onready var held_item_icon = $HeldItemIcon
@onready var animated_sprite = $AnimatedSprite2D # <--- CHANGED: References AnimatedSprite2D

# VARIABLES
@export var speed = 150.0
const JUMP_VELOCITY = -400.0
@export var lerp_amount = 0.1

func _ready() -> void:
	SignalBus.delivery_result.connect(_on_delivery_result)

func _on_delivery_result(was_successful: bool):
	drop_item()

func _physics_process(delta):
	# Movement
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var target_velocity = input_vector * speed
	velocity = velocity.lerp(target_velocity, lerp_amount)
	move_and_slide()
	
	# Interact raycast rotation
	if input_vector != Vector2.ZERO:
		interact_ray.target_position = input_vector * 40.0 
	
	# --- ANIMATION LOGIC ---
	if input_vector.y > 0:
		animated_sprite.play("forward_walk") # Down
	elif input_vector.y < 0:
		animated_sprite.play("backwards_walk") # Up
	elif input_vector.x != 0:
		# Handle side walking
		animated_sprite.flip_h = input_vector.x < 0 # Flip if moving left
		animated_sprite.play("idle") # Ensure you have this animation, or use "forward_walk"
	else:
		animated_sprite.play("idle") # Stop
	# -----------------------

	# INTERACTION INPUT
	if Input.is_action_just_pressed("interact"): 
		_attempt_interact()
		
	if Input.is_action_just_pressed("drop"): 
		drop_item()

func _attempt_interact():
	if interact_ray.is_colliding():
		var object = interact_ray.get_collider()
		if object.has_method("interact"):
			object.interact(self)

# --- PUBLIC FUNCTIONS ---

func pickup(item_resource: Resource):
	if item_resource.resource_path.ends_with("rat_tail.tres"):
		if GameManager.rat_score <= 0:
			return
	
	held_item = item_resource
	print("Picked up: ", held_item.resource_path)
	
	if held_item.resource_path.ends_with("rat_tail.tres"):
		SignalBus.rat_score_updated.emit()
		
	SignalBus.item_picked_up.emit()
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
