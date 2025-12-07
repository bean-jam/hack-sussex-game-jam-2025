extends AudioStreamPlayer # or Node, depending on your structure

func _ready():
	# Connect to the SAME signal your GameManager uses
	SignalBus.rat_squished.connect(_on_rat_squished)

func _on_rat_squished():
	# Optional: Add variety
	pitch_scale = randf_range(0.8, 1.2)
	
	# Play the sound
	play()
