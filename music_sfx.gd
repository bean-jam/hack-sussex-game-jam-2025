extends AudioStreamPlayer

# SETTINGS
var start_speedup_at: float = 30.0 # Start speeding up at 60 seconds
var max_pitch: float = 2.0        # How fast the music gets at 0 seconds
var normal_pitch: float = 1.0

func _ready():
	# Connect to the signal
	SignalBus.time_updated.connect(_on_time_updated)
	
	# Ensure music is playing
	if not playing:
		play()

func _on_time_updated(time_left: float):
	# 1. If we have plenty of time, keep pitch normal
	if time_left > start_speedup_at:
		pitch_scale = normal_pitch
		
	# 2. If time is running out, scale the pitch smoothly
	else:
		# LOGIC:
		# As time_left goes from 60 -> 0...
		# We map that range to fit between 1.0 -> 1.2
		
		# remap(value, input_min, input_max, output_min, output_max)
		var new_pitch = remap(time_left, start_speedup_at, 0.0, normal_pitch, max_pitch)
		
		pitch_scale = new_pitch
