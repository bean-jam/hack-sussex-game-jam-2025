extends Area2D

# Movement speed (random range)
@export var speed: int = 50

# Current direction of movement
var velocity: Vector2 = Vector2.ZERO
var screen_size: Vector2
var direction: int = 1 # 1 for right, -1 for left
signal rat_squished

func _ready():
	randomize()
	update_sprite_flip()
	change_direction()

# Called every frame
func _process(delta):
	position += velocity * speed * delta

	check_offscreen_despawn()

func check_offscreen_despawn():
	var screen_width = get_viewport_rect().size.x
	
	if position.x < -100 or position.x > screen_width + 100:
		despawn()

func despawn():
	rat_squished.emit()
	queue_free()
	print("enemy despawned")

func change_direction():
	var random_angle = randf() * 2 * PI
	velocity = Vector2(cos(random_angle), sin(random_angle))
	velocity.y = velocity.y / 5.0
	velocity = velocity.normalized()
	direction = 1 if velocity.x >= 0 else -1
	update_sprite_flip()

func update_sprite_flip():
	# Assumes your Sprite2D is a child named "Sprite2D"
	if is_node_ready() and has_node("Sprite2D"):
		$Sprite2D.flip_h = (direction == -1)

func _on_area_entered(area: Area2D):
	# Check if the object we collided with is in the "rat" group
	if area.is_in_group("rat") and area != self:
		direction *= -1
		update_sprite_flip()
		position.x += direction * 5 # Nudge away

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		print("Enemy clicked!")
		die() # Call the function to kill the enemy

func die():
	rat_squished.emit()
	queue_free()

# Sets a new, random velocity vector
#func change_direction():
	## Get a random angle in radians (0 to 2*PI)
	#randomize()
	#if randi() % 2 == 0:
		#direction = -1 # Start moving left
		#$Sprite2D.flip_h = (direction == -1)
	#else:
		#direction = 1 # Start moving right
	#
	#var random_angle = randf() * 2 * PI
	## Convert the angle to a unit vector and store it in velocity
	#velocity = Vector2(cos(random_angle), sin(random_angle))
