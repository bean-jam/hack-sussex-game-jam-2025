# Cauldron.gd
extends Node2D


# 1. Ingredients currently in the cauldron
# The Item objects dropped into the cauldron
var current_ingredients: Array[Item] = [] 


# 2. List of all possible recipes
# Drag your Recipe resource files into this array in the editor
@export var all_recipes: Array[Recipe] = [] 

# --- Functions ---

# Called when the player drops an item into the cauldron area
func add_ingredient(item: Item):
	current_ingredients.append(item)
	print("Added %s. Total items: %d" % [item.item_name, current_ingredients.size()])
	
	# Optional: Check immediately after adding an item
	# check_for_recipe_match()

# Called when the player interacts (e.g., clicks 'Brew')
func brew():
	var result = check_for_recipe_match()
	
	if result != null:
		print("Success! Brewed a %s" % result.item_name)
		# 1. Clear the ingredients
		current_ingredients.clear() 
		# 2. Return the result (e.g., spawn the Potion item object)
		return result
	else:
		print("Brew failed. The ingredients do not match any recipe.")
		# Optional: return the ingredients to the player or destroy them

func check_for_recipe_match() -> Item:
	# 1. Only proceed if we have ingredients
	if current_ingredients.is_empty():
		return null

	# 2. Iterate through every known recipe
	for recipe in all_recipes:
		# Check if the ingredient count matches the recipe count
		if current_ingredients.size() != recipe.required_items.size():
			continue # Go to the next recipe

		# 3. Check if the items themselves match
		if _are_ingredients_equal(current_ingredients, recipe.required_items):
			return recipe.result_potion # Found a match!

	# 4. No recipe was matched
	return null


# --- Helper Function ---

# Compares two arrays of Item objects to see if they contain the same items.
# NOTE: This assumes order doesn't matter. If order matters, you can skip sorting.
func _are_ingredients_equal(list_a: Array[Item], list_b: Array[Item]) -> bool:
	if list_a.size() != list_b.size():
		return false

	# To check for content equality regardless of order, we sort both lists 
	# and then compare them. We sort by the unique item name.
	
	# Duplicate the arrays before sorting so we don't change the original order
	var sorted_a = list_a.duplicate() 
	var sorted_b = list_b.duplicate()

	# Sort the arrays based on the 'item_name' property
	sorted_a.sort_custom(func(item1, item2): return item1.item_name < item2.item_name)
	sorted_b.sort_custom(func(item1, item2): return item1.item_name < item2.item_name)

	# Now compare the sorted names, item by item
	for i in range(sorted_a.size()):
		if sorted_a[i].item_name != sorted_b[i].item_name:
			return false

	# If we made it this far, the lists contain the same items.
	return true
