extends Area2D

# Movement speed (random range)
@export var speed: int = 50
@export var ceiling_y: float = 100.0
@export var floor_y: float = 210.0
var rat_score: int = 1
# Current direction of movement
var velocity: Vector2 = Vector2.ZERO
var screen_size = get_viewport_rect().size
var direction: int = 1 # 1 for right, -1 for left

signal rat_despawned 

func _ready():
	randomize()
	update_sprite_flip()
	change_direction() # This will be called a second time by the Spawner, but that's fine.

# Called every frame
func _process(delta):
	position += velocity * speed * delta
	# Ceiling and Floor Bounds
	if position.y < ceiling_y:
		position.y = ceiling_y
		if velocity.y < 0:
			velocity.y *= -1
	
	if position.y >= floor_y:
		position.y = floor_y
		velocity.y *= -1
		
	check_offscreen_despawn()

func check_offscreen_despawn():
	var screen_width = get_viewport_rect().size.x
	
	# Use the original despawn boundary
	if position.x < -100 or position.x > screen_width + 100:
		despawn()

func despawn():
	rat_despawned.emit() 
	queue_free()
	print("enemy despawned")

func change_direction():
	var random_angle = randf() * 2 * PI
	velocity = Vector2(cos(random_angle), sin(random_angle))
	velocity.y = velocity.y / 5.0
	velocity = velocity.normalized()
	direction = 1 if velocity.x >= 0 else -1
	update_sprite_flip()
	
# ... (rest of the script is the same)
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
	SignalBus.rat_squished.emit()
	queue_free()
