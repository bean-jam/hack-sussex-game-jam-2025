extends PanelContainer

@onready var container = $IngredientContainer

# Define standard icon size
const ICON_SIZE = Vector2(64, 64)

func _ready():
	# Start hidden until a customer arrives
	visible = false
	
	# Listen for the Customer arriving
	SignalBus.customer_at_desk.connect(_on_customer_arrived)
	
	# Listen for the result (to hide the UI when done)
	SignalBus.delivery_result.connect(_on_delivery_result)

func _on_customer_arrived(potion_data: Resource):
	# 1. Clear previous recipe
	_clear_icons()
	
	# 2. Check if this is actually a Potion with ingredients
	if "required_items" in potion_data:
		visible = true
		var ingredients_list = potion_data.required_items
		
		# 3. Create an icon for every ingredient in the list
		for ingredient in ingredients_list:
			var icon = TextureRect.new()
			
			# Safety check for texture
			if ingredient and "texture" in ingredient:
				icon.texture = ingredient.texture
			
			# Setup sizing
			icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icon.custom_minimum_size = ICON_SIZE
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			
			container.add_child(icon)
			
			# OPTIONAL: Add a "Plus" sign between ingredients?
			# (Logic: if not the last item, add a Label with "+")

	else:
		# If it's just a simple item with no recipe, maybe hide or show just the item?
		print("UI: Item has no recipe list.")
		visible = false

func _on_delivery_result(_success):
	# Hide the recipe when the transaction is over
	visible = false
	_clear_icons()

func _clear_icons():
	for child in container.get_children():
		child.queue_free()
