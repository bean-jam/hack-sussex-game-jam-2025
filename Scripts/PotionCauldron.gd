extends StaticBody2D

# --- CONFIGURATION ---
# Drag ALL valid Potion recipes here (LovePotion.tres, Cure.tres, etc.)
@export var known_recipes: Array[Potion] 

# Drag your PissPotion.tres here
@export var failure_potion: Potion 

# --- STATE ---
var current_ingredients: Array[Item] = []

func interact(player):
	print("Cauldron")
	# CASE 1: ADDING AN INGREDIENT
	# If player is holding something that is NOT a potion (i.e. an ingredient)
	if player.held_item != null:
		# (Optional: Check if it's actually an ingredient and not a finished potion)
		_add_ingredient(player.held_item)
		player.drop_item()
		return

	# CASE 2: COOKING / COLLECTING
	# If player hand is empty and cauldron has stuff, try to cook!
	if player.held_item == null and current_ingredients.size() > 0:
		_cook_potion(player)

func _add_ingredient(item: Item):
	current_ingredients.append(item)
	print("Added: " + item.item_name)
	
	# Visuals: You could play a splash sound or add a small sprite floating above
	SignalBus.ingredient_added.emit(item.item_name)

func _cook_potion(player):
	print("Cooking with: ", current_ingredients)
	
	# 1. Find a match
	var result_potion = _check_recipes()
	
	# 2. Give result to player
	player.pickup(result_potion)
	
	# 3. Reset Cauldron
	current_ingredients.clear()
	print("Cauldron emptied. Created: ", result_potion.item_name)

# --- THE RECIPE LOGIC ---
func _check_recipes() -> Potion:
	# We sort the current ingredients by resource path (unique ID) to normalize order
	# This ensures [Rat, Frog] is treated the same as [Frog, Rat]
	var current_sorted = _get_sorted_paths(current_ingredients)
	
	for recipe in known_recipes:
		# Get the recipe's required ingredients sorted the same way
		var recipe_sorted = _get_sorted_paths(recipe.required_ingredients)
		
		# Compare the Arrays
		if current_sorted == recipe_sorted:
			return recipe # MATCH FOUND!
			
	# If loop finishes with no match:
	return failure_potion

# Helper to turn an array of Items into a sorted array of Strings (paths)
func _get_sorted_paths(item_list: Array[Item]) -> Array:
	var paths = []
	for item in item_list:
		if item:
			paths.append(item.resource_path)
	paths.sort()
	return paths
