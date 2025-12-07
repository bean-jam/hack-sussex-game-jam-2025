extends CharacterBody2D

# STATE
var held_item: Item = null

# NODES
# --- CHANGED: Replaced InteractRay with InteractionArea ---
@onready var interaction_area = $InteractionArea 
@onready var held_item_icon = $HeldItemIcon
@onready var animated_sprite = $AnimatedSprite2D

# VARIABLES
@export var speed: int = 150

func _ready() -> void:
	SignalBus.delivery_result.connect(_on_delivery_result)

func _on_delivery_result(was_successful: bool):
	drop_item()

func _physics_process(delta):
	# Movement
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * speed
	move_and_slide()
	
	# --- REMOVED: Raycast rotation logic is no longer needed ---
	# The Area2D surrounds the player, so we don't need to rotate it.
	
	# --- ANIMATION LOGIC ---
	if input_vector.y > 0:
		animated_sprite.play("forward_walk")
	elif input_vector.y < 0:
		animated_sprite.play("backwards_walk")
	elif input_vector.x != 0:
		animated_sprite.flip_h = input_vector.x < 0
		animated_sprite.play("sideways_walk")
	else:
		animated_sprite.play("idle") 
	# -----------------------

	# INTERACTION INPUT
	if Input.is_action_just_pressed("interact"): 
		_attempt_interact()
		
	if Input.is_action_just_pressed("drop"): 
		drop_item()

# --- NEW: Logic to find the closest interactable object ---
func _attempt_interact():
	# 1. Get everything inside the circle
	var overlapping_bodies = interaction_area.get_overlapping_bodies()
	
	# Note: If your items are Areas (not Bodies), use:
	# var overlapping_areas = interaction_area.get_overlapping_areas()
	# overlapping_bodies.append_array(overlapping_areas)

	var closest_obj = null
	var closest_dist = INF # Start with 'Infinity'

	# 2. Loop through them to find the closest valid one
	for obj in overlapping_bodies:
		if obj == self:
			continue # Don't interact with yourself!
			
		if obj.has_method("interact"):
			var dist = global_position.distance_squared_to(obj.global_position)
			if dist < closest_dist:
				closest_dist = dist
				closest_obj = obj

	# 3. Interact with the winner
	if closest_obj:
		closest_obj.interact(self)

# --- PUBLIC FUNCTIONS (Unchanged) ---

func pickup(item_resource: Resource):
	if item_resource.resource_path.ends_with("rat_tail.tres"):
		if GameManager.rat_score <= 0:
			return
		# Remember to use the fix from the previous question here!
		GameManager.consume_rat_tail() 
	
	held_item = item_resource
	print("Picked up: ", held_item.resource_path)
	
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
