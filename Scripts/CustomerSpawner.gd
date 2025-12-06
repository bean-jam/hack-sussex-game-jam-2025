extends Node
class_name CustomerSpawner

# DRAG YOUR CUSTOMER SCENE HERE IN INSPECTOR
@export var customer_scene: PackedScene 

# CHANGE: Type must be Array[Resource] or Array[Item] to hold a list
@export var possible_orders: Array[Resource] 

@export var spawn_interval: float = 5.0
var timer: float = 0.0

func _process(delta):
	timer -= delta
	if timer <= 0:
		spawn_customer()
		timer = spawn_interval # Reset timer

func spawn_customer():
	# 1. Create the instance
	var new_customer = customer_scene.instantiate()
	
	# 2. Pick a random order
	if possible_orders.size() > 0:
		# .pick_random() only works on Arrays
		var random_potion = possible_orders.pick_random()
		
		# Ensure your Customer script has this function!
		new_customer.setup_order(random_potion)
	else:
		print("ERROR: No potions assigned to 'Possible Orders' in the Spawner!")
	
	# 3. Add to scene
	get_parent().add_child(new_customer)
	
	# Optional: Set their Y position to match the floor
	new_customer.global_position.y = 400
