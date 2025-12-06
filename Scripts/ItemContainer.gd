extends StaticBody2D

# EXPORT A RESOURCE INSTEAD OF A STRING
# Drag the .tres file (e.g. Frog.tres) into this slot in the Inspector
@export var ingredient_data: Resource 

func interact(player):
	# Check if player is holding nothing (null)
	if player.held_item == null:
		if ingredient_data != null:
			player.pickup(ingredient_data)
		else:
			print("ERROR: No Resource assigned to this station in Inspector!")
	else:
		print("Player hands are full!")
