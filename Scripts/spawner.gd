extends Node2D

@export var enemy_scene: PackedScene

@export var max_enemies: int = 10

var current_enemies: int = 0
var screen_size: Vector2

func _ready():
	"""Gets the spawner ready
	Sets screen size and starts timer"""
	# Get screen boundaries
	screen_size = get_viewport_rect().size
	# Connect the Timer signal to the spawn function
	$SpawnTimer.timeout.connect(spawn_enemy)
	# Start the Timer 
	$SpawnTimer.start()
	print("spawner ready")


func spawn_enemy():
	if current_enemies >= max_enemies:
		return # Don't spawn if we hit the limit

	var enemy = enemy_scene.instantiate()

	# Determine random starting side (left or right) and Y position
	randomize()
	var start_left = randi() % 2 == 0 
	var rand_y = randf_range(50, screen_size.y - 50) 

	if start_left:
		enemy.position = Vector2(-10, 150)
		enemy.direction = 1 # Force it to move right
	else:
		enemy.position = Vector2(screen_size.x + 10, 150)
		enemy.direction = -1 # Force it to move left
		
	enemy.rat_squished.connect(on_enemy_died)
	
	add_child(enemy)
	current_enemies += 1
	print("Spawning Rat at position: ", enemy.position)
	print("enemy spawned")

# This function is called when an enemy is clicked and calls 'die()'
func on_enemy_died():
	print("Enemy killed!")
	current_enemies -= 1
