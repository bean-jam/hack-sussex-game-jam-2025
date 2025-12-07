extends Node

# Get references to the children nodes
@onready var squish_player = $rat_squish_sfx
@onready var item_grab = $item_grab_sfx

func _ready():
	# Connect to the signals from the SignalBus
	SignalBus.rat_squished.connect(_on_rat_squished)
	SignalBus.item_picked_up.connect(_on_item_picked_up)
	

func _on_rat_squished():
	# Optional: Add logic here (like pitch randomization)
	squish_player.pitch_scale = randf_range(0.8, 1.2)
	
	# Tell the child to play
	squish_player.play()

func _on_item_picked_up():
	# When item picked up
	item_grab.pitch_scale = randf_range(0.9, 1.1)
	item_grab.play()
