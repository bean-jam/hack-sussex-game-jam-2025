extends CharacterBody2D
class_name BaseCustomer

# --- SETTINGS ---
@export var movement_speed: float = 100.0
@export var desk_position_x: float = 208.0 
@export var spawn_position_x: float = 500.0

# TARGET: We want to reach -100 (Left side of screen)
@export var despawn_position_x: float = -100.0 

# --- STATE ---
enum State { WALKING_IN, WAITING, WALKING_OUT }
var current_state = State.WALKING_IN
var desired_item: Item = null 

@onready var order_bubble = $OrderBubble

func _ready():
	global_position.x = spawn_position_x
	order_bubble.visible = false
	
	# LISTEN for the Manager's judgment
	SignalBus.delivery_result.connect(_on_delivery_result)

func _physics_process(delta):
	match current_state:
		State.WALKING_IN:
			# Move LEFT (-) towards desk
			velocity.x = -movement_speed
			move_and_slide()
			
			# Check if we passed the desk (Less than)
			if global_position.x <= desk_position_x:
				current_state = State.WAITING
				_show_order()
				# TELL MANAGER we arrived!
				SignalBus.customer_at_desk.emit(desired_item)
				
		State.WAITING:
			velocity = Vector2.ZERO
			
		State.WALKING_OUT:
			# --- FIX 1: MOVE LEFT (-) ---
			# We want to go from 208 to -100, so we keep subtracting X
			velocity.x = -movement_speed 
			move_and_slide()
			
			# --- FIX 2: CHECK IF PAST THE LEFT EDGE (<) ---
			# We check if X is LESS than -100
			if global_position.x < despawn_position_x:
				queue_free()

# --- INTERACTION LOGIC ---
func interact(player):
	if current_state == State.WAITING:
		if player.held_item == null:
			print("Customer: I am waiting for an order!")
			return

		# ASK MANAGER to check the item (Matches your Game Manager logic)
		print("Customer: Sending item to Manager for inspection...")
		SignalBus.attempt_delivery.emit(player.held_item)

# --- SIGNAL RESPONSES ---
func _on_delivery_result(was_successful: bool):
	if current_state == State.WAITING:
		if was_successful:
			print("Customer: Thank you!")
			
			# SUCCESS: Green Glow + Slightly Ghostly (0.8 Alpha)
			modulate = Color(0.5, 2.0, 0.5, 0.8) 
			
			current_state = State.WALKING_OUT
			order_bubble.visible = false
			
		else:
			print("Customer: This isn't what I asked for!")
			
			# FAILURE: Red Glow + Slightly Ghostly (0.8 Alpha)
			modulate = Color(2.0, 0.5, 0.5, 0.8)
			
			current_state = State.WALKING_OUT
			order_bubble.visible = false

# --- SETUP FUNCTION ---
func setup_order(random_potion: Item):
	desired_item = random_potion

func _show_order():
	order_bubble.visible = true
	if desired_item and "texture" in desired_item:
		order_bubble.texture = desired_item.texture
