extends CharacterBody2D
class_name BaseCustomer

# --- SETTINGS ---
@export var movement_speed: float = 100.0
@export var desk_position_x: float = 208.0 # Change this to your desk's X coordinate
@export var spawn_position_x: float = 500.0 # Off-screen right
@export var despawn_position_x: float = -100.0 # Off-screen right


# --- STATE ---
enum State { WALKING_IN, WAITING, WALKING_OUT }
var current_state = State.WALKING_IN
var desired_item: Item = null # The Resource they want

# --- NODES ---
@onready var order_bubble = $OrderBubble

func _ready():
	# Start at spawn point
	global_position.x = spawn_position_x
	order_bubble.visible = false # Hide bubble while walking in

func _physics_process(delta):
	match current_state:
		State.WALKING_IN:
			# Move Left towards desk
			velocity.x = -movement_speed
			move_and_slide()
			
			# Check if arrived at desk (tolerance of 5 pixels)
			if global_position.x <= desk_position_x:
				current_state = State.WAITING
				_show_order()
				
		State.WAITING:
			velocity = Vector2.ZERO # Stop moving
			
		State.WALKING_OUT:
			# Move left to leave
			velocity.x = movement_speed
			move_and_slide()
			
			# Destroy object when off screen
			if global_position.x > despawn_position_x:
				queue_free()

# --- INTERACTION LOGIC ---
# This matches the function call from your Player's RayCast
func interact(player):
	if current_state == State.WAITING:
		# 1. Player has NO item?
		if player.held_item == null:
			print("Customer: I am waiting for an order!")
			return

		# 2. Player has an item. Is it the RIGHT one?
		if player.held_item == desired_item:
			print("Customer: Thank you! This is exactly what I wanted.")
			
			# Take item from player (clear their hand)
			player.drop_item() 
			
			# Leave
			current_state = State.WALKING_OUT
			order_bubble.visible = false
			
			# TODO: Add Score here later!
		else:
			print("Customer: Eww! I didn't ask for " + player.held_item.item_name)

# --- SETUP FUNCTION ---
func setup_order(random_potion: Item):
	desired_item = random_potion

func _show_order():
	order_bubble.visible = true
	if desired_item and desired_item.texture:
		order_bubble.texture = desired_item.texture
