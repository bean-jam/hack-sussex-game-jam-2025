extends Area2D

# Movement speed (random range)
@export var speed: int = 60 
@export var ceiling_y: float = 70 # How high they can go
var rat_score: int = 1
# Current direction of movement
var velocity: Vector2 = Vector2.ZERO
var screen_size: Vector2
var direction: int = 1
var is_dead: bool = false

# Boundary margin for sides
const SIDE_MARGIN = 40

signal rat_despawned

func _ready():
	screen_size = get_viewport_rect().size
	input_pickable = true
	randomize()
	update_sprite_flip()

# Called every frame
func _process(delta):
	if is_dead:
		return
		
	position += velocity * speed * delta
	
	# --- 1. BOUNCE OFF CEILING (Top Limit) ---
	if position.y < ceiling_y:
		position.y = ceiling_y
		# If moving up, bounce down
		if velocity.y < 0:
			velocity.y *= -1

	# --- 2. BOUNCE OFF SIDES (10px Margin) ---
	# Left Wall
	if position.x < SIDE_MARGIN:
		position.x = SIDE_MARGIN
		velocity.x = abs(velocity.x) # Force Right
		update_sprite_flip()
		
	# Right Wall
	if position.x > screen_size.x - SIDE_MARGIN:
		position.x = screen_size.x - SIDE_MARGIN
		velocity.x = -abs(velocity.x) # Force Left
		update_sprite_flip()

	# --- 3. CHECK DESPAWN (Bottom of screen) ---
	check_offscreen_despawn()

func check_offscreen_despawn():
	if is_dead:
		return
	# Only despawn if we are below the screen AND moving down
	# (screen_size.y + 100 gives a little buffer so they don't pop out instantly)
	if position.y > screen_size.y + 100 and velocity.y > 0:
		despawn()

func despawn():
	rat_despawned.emit() 
	queue_free()
	print("enemy despawned")

func change_direction():
	if is_dead:
		return
	var random_angle = randf() * 2 * PI
	velocity = Vector2(cos(random_angle), sin(random_angle))
	velocity.y = velocity.y / 5.0
	velocity = velocity.normalized()
	direction = 1 if velocity.x >= 0 else -1
	update_sprite_flip()
	
# ... (rest of the script is the same)
func update_sprite_flip():
	# Assumes your Sprite2D is a child named "Sprite2D"
	if is_node_ready() and has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.flip_h = (direction == 1)

func _on_area_entered(area: Area2D):
	# Check if the object we collided with is in the "rat" group
	if area.is_in_group("Rat") and area != self:
		direction *= -1
		update_sprite_flip()
		position.x += direction * 5 # Nudge away

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if is_dead:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		print("Enemy clicked!")
		die() # Call the function to kill the enemy

func die():
	is_dead = true
	SignalBus.rat_squished.emit()
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("splat")
	
	var tween = create_tween()
	tween.tween_interval(5.0)
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	
	
	tween.tween_callback(queue_free)
	#await get_tree().create_timer(1.0).timeout
	#queue_free()
