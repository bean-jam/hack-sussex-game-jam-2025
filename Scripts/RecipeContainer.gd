extends PanelContainer

@onready var container = $IngredientContainer

func _ready():
	# Start hidden until a customer arrives
	visible = false
	
	SignalBus.customer_at_desk.connect(_on_customer_arrived)
	SignalBus.delivery_result.connect(_on_delivery_result)

func _on_customer_arrived(potion_data: Resource):
	_clear_icons()
	
	if "required_items" in potion_data:
		visible = true
		var ingredients_list = potion_data.required_items
		
		for ingredient in ingredients_list:
			var icon = TextureRect.new()
			
			if ingredient and "texture" in ingredient:
				icon.texture = ingredient.texture
			
			# --- PIXEL PERFECT SETTINGS ---
			icon.stretch_mode = TextureRect.STRETCH_KEEP
			icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
			
			# --- CENTERING FIX ---
			# SIZE_SHRINK_CENTER tells it to center itself on the vertical axis (Y)
			# SIZE_SHRINK_BEGIN is usually the default (Top)
			icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			
			container.add_child(icon)

	else:
		print("UI: Item has no recipe list.")
		visible = false

func _on_delivery_result(_success):
	visible = false
	_clear_icons()

func _clear_icons():
	for child in container.get_children():
		child.queue_free()
