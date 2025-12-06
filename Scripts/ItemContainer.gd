extends StaticBody2D

# CHANGE THIS per object in the Inspector (e.g., "Frog", "Rat", "Cards")
@export var item_name: String = "Rat"

func interact(player):
	# Only give item if player hands are empty
	if player.held_item == "":
		player.pickup(item_name)
	else:
		print("Player hands are full!")
