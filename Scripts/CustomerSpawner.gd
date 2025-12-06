extends Node
class_name CustomerSpawner

# DRAG YOUR CUSTOMER SCENE HERE IN INSPECTOR
@export var customer_scene: PackedScene 

# DRAG POTIONS HERE
@export var possible_orders: Array[Resource] 

func _ready() -> void:
	# Wait one frame to ensure the scene is fully loaded
	await get_tree().process_frame
	
	print("Spawner: Ready. Initializing first customer...")
	spawn_customer()
	
	# Connect signal
	SignalBus.delivery_result.connect(_on_delivery)

# The signal sends a boolean, so we must accept it
func _on_delivery(_was_successful: bool) -> void:
	# Optional: Add a small delay so they don't overlap too much
	await get_tree().create_timer(1.0).timeout
	spawn_customer()

func spawn_customer():
	# 1. Safety Checks
	if customer_scene == null:
		print("ERROR: Customer Scene is empty in the Spawner Inspector!")
		return
		
	print("Spawner: Spawning Customer...")

	# 2. Instantiate
	var new_customer = customer_scene.instantiate()
	
	# 3. Add to the ROOT of the scene (Fixes coordinate/visibility issues)
	get_tree().current_scene.add_child(new_customer)
	
	# 4. Set Position (Hard set Y to 120, X comes from Customer script)
	new_customer.global_position.y = 120
	
	# 5. Handle Order
	if possible_orders.size() > 0:
		var random_potion = possible_orders.pick_random()
		new_customer.setup_order(random_potion)
	else:
		print("WARNING: No potions in 'Possible Orders'. Spawning customer with no order.")
