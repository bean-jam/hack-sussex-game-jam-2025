extends Area2D

# Movement speed
@export var speed: float = 100.0

# Current direction of movement
var velocity: Vector2 = Vector2.ZERO
var screen_size: Vector2 # Hold screen suze

func _ready():
	# Get screen boundaries
	screen_size = get_viewport_rect().size
	# initial random direction
	randomize() # new seed each time
	change_direction()

# Called every frame
func _process(delta):
	# 3. Move the enemy in the current direction
	position += velocity * speed * delta
	
	# 4. Keep the enemy within screen bounds and change direction when hitting an edge
	check_boundaries()

# Sets a new, random velocity vector
func change_direction():
	# Get a random angle in radians (0 to 2*PI)
	var random_angle = randf() * 2 * PI
	# Convert the angle to a unit vector and store it in velocity
	velocity = Vector2(cos(random_angle), sin(random_angle))

func check_boundaries():
	var new_velocity = velocity
	var hit_boundary = false
	
	# Check horizontal bounds
	if position.x < 0 or position.x > screen_size.x:
		# Flip the X direction
		new_velocity.x = -new_velocity.x
		hit_boundary = true
		# Clamp position to prevent getting stuck
		position.x = clamp(position.x, 0, screen_size.x)

	# Check vertical bounds
	if position.y < 0 or position.y > screen_size.y:
		# Flip the Y direction
		new_velocity.y = -new_velocity.y
		hit_boundary = true
		# Clamp position to prevent getting stuck
		position.y = clamp(position.y, 0, screen_size.y)
		
	if hit_boundary:
		# Update velocity if a boundary was hit
		velocity = new_velocity.normalized()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		print("Enemy clicked!")
		die() # Call the function to kill the enemy

func die():
	# 1. Emit a signal to tell the rest of the game the enemy was killed (optional but recommended)
	# This requires defining the signal at the top of the script: signal enemy_died(score_value)
	# emit_signal("enemy_died", 100) # Example signal

	# 2. Add an effect (e.g., sound, particle effect) here
	
	# 3. Remove the enemy from the scene
	queue_free()
