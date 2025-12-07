extends Node2D

@export var enemy_scene: PackedScene

@export var max_enemies: int = 30

var current_enemies: int = 0
var screen_size: Vector2
# Define the absolute safe spawn boundary (10 pixels inside the -100 despawn line)
const SAFE_SPAWN_X_OFFSET = 90 

func _ready():
	"""Gets the spawner ready
	Sets screen size and starts timer"""
	screen_size = get_viewport_rect().size
	$SpawnTimer.timeout.connect(spawn_enemy)
	$SpawnTimer.start()
	
	# Connect to global signal to track deaths
	SignalBus.rat_squished.connect(on_enemy_died)
	print("spawner ready")
	randomize()


func spawn_enemy():
	if current_enemies >= max_enemies:
		return 

	var enemy = enemy_scene.instantiate()
# 1. Start Position: Random X at the bottom
	# We use a wider range so they don't hug the walls instantly
	var start_x = randf_range(20, screen_size.x - 20)
	var start_y = screen_size.y + 60 
	enemy.position = Vector2(start_x, start_y)
	
	# 2. Target Position: Pick a random spot near the CEILING
	# This ensures every rat is "aiming" for the play area
	var target_x = randf_range(20, screen_size.x - 20)
	var target_y = 50.0 # This should match your Rat's 'ceiling_y'
	
	var target_position = Vector2(target_x, target_y)
	
	# 3. Calculate Direction (Target - Start)
	# This gives us a vector pointing exactly from spawn to target
	var direction_vector = (target_position - enemy.position).normalized()
	
	# 4. OPTIONAL: Flatten the angle further?
	# If you want them to be REALLY diagonal, you can multiply the X component
	# direction_vector.x *= 1.5 
	# direction_vector = direction_vector.normalized() # Re-normalize after tweaking
	
	enemy.velocity = direction_vector
	
	add_child(enemy)
	current_enemies += 1
	enemy.rat_despawned.connect(on_enemy_despawned)
	
	
	# IMPORTANT: Do NOT call enemy.change_direction() here anymore, 
	# because that would randomize the velocity and overwrite our "Upward" push.
	
	current_enemies += 1
	print("Spawning Rat at position: ", enemy.position)
	print("enemy spawned")

func on_enemy_died():
	print("Enemy killed!")
	current_enemies -= 1

func on_enemy_despawned():
	print("Enemy despawned off-screen!")
	current_enemies -= 1
	print("Current enemies after despawn: ", current_enemies)
