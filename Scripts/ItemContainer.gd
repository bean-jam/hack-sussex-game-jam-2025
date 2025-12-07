@tool 
extends StaticBody2D
# ADD THIS TOOL KEYWORD TO SEE CHANGES IN EDITOR WITHOUT RUNNING


# EXPORT A RESOURCE INSTEAD OF A STRING
@export var ingredient_data: Resource:
	set(value):
		ingredient_data = value
		_update_sprite() # Update immediately when you drag a file in

func _ready():
	_update_sprite()

func _update_sprite():
	# 1. Check if we have data and a sprite node
	if ingredient_data and has_node("Sprite2D"):
		# 2. Check if the resource has a texture/icon property
		if "texture" in ingredient_data:
			$Sprite2D.texture = ingredient_data.texture
		elif "icon" in ingredient_data:
			$Sprite2D.texture = ingredient_data.icon
			
func interact(player):
	# Check if player is holding nothing (null)
	if player.held_item == null:
		if ingredient_data != null:
			player.pickup(ingredient_data)
		else:
			print("ERROR: No Resource assigned to this station in Inspector!")
	else:
		print("Player hands are full!")
