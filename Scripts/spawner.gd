extends Node2D

# The enemy scene file (drag your saved Enemy scene here in the Inspector)
@export var enemy_scene: PackedScene 

# How many enemies should be on screen at any time
@export var max_enemies: int = 10

var current_enemies: int = 0
var screen_size: Vector2


func _ready():
	# 1. Get screen boundaries
	screen_size = get_viewport_rect().size
	# 2. Connect the Timer signal to the spawn function
	$SpawnTimer.timeout.connect(spawn_enemy)
	# Start the Timer if it wasn't set to Autostart
	$SpawnTimer.start()

func spawn_enemy():
	if current_enemies >= max_enemies:
		return # Don't spawn if we hit the limit

	# 1. Create a new instance of the enemy scene
	var enemy = enemy_scene.instantiate()

	# 2. Determine random starting side (left or right) and Y position
	randomize()
	var start_left = randi() % 2 == 0
	var rand_y = randf_range(50.0, screen_size.y - 50.0) # Spawn enemies vertically between 50 and screen height - 50

	if start_left:
		# Start on the left, slightly off-screen
		enemy.position = Vector2(-100, rand_y)
		enemy.direction = 1 # Force it to move right
	else:
		# Start on the right, slightly off-screen
		enemy.position = Vector2(screen_size.x + 100, rand_y)
		enemy.direction = -1 # Force it to move left
		
	# 3. Connect the enemy's 'died' signal to the spawner's 'on_enemy_died' function
	enemy.died.connect(on_enemy_died)
	
	# 4. Add the enemy to the scene and update the count
	add_child(enemy)
	current_enemies += 1

# This function is called when an enemy is clicked and calls 'die()'
func on_enemy_died(score: int):
	print("Enemy killed! Score: ", score)
	current_enemies -= 1
	# Since the timer is running, a new enemy will spawn soon (respawn effect)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
