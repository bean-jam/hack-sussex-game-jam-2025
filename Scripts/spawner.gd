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
	print("spawner ready")


func spawn_enemy():
	if current_enemies >= max_enemies:
		return 

	var enemy = enemy_scene.instantiate()

	randomize()
	var start_left = randi() % 2 == 0
	var rand_y = randf_range(180, screen_size.y - 50)
	
	# 1. Set position just inside the despawn boundary (The Clamp)
	if start_left:
		# Spawn at x = -90 (inside the x < -100 despawn zone)
		enemy.position = Vector2(-SAFE_SPAWN_X_OFFSET, rand_y) 
		enemy.direction = 1
		# Set a strong inward velocity
		enemy.velocity = Vector2(1.0, 0.0) 
	else:
		# Spawn at x = screen_size.x + 90 (inside the x > screen_size.x + 100 despawn zone)
		enemy.position = Vector2(screen_size.x + SAFE_SPAWN_X_OFFSET, rand_y) 
		enemy.direction = -1
		# Set a strong inward velocity
		enemy.velocity = Vector2(-1.0, 0.0) 
		
	# Connect the signals
	enemy.rat_despawned.connect(on_enemy_despawned)
	
	add_child(enemy)
	
	# 2. Call change_direction, which will normalize velocity and add Y-axis randomness, 
	# but the dominant X direction is already set to move INWARD.
	enemy.change_direction() 
	
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
