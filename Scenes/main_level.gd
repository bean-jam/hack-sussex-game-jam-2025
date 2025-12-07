extends Node2D 

const GAME_OVER_SCENE = preload("res://Scenes/game_over_screen.tscn")

func _ready():
	# Listen for the day to end
	SignalBus.day_ended.connect(_on_day_ended)

func _on_day_ended():
	print("Level: Day ended, showing summary.")
	
	var screen = GAME_OVER_SCENE.instantiate()
	
	# 1. Create a new CanvasLayer dynamically
	var ui_layer = CanvasLayer.new()
	ui_layer.layer = 100 # Make sure it's on top of everything
	
	# 2. Add the screen to the layer, and the layer to the scene
	ui_layer.add_child(screen)
	add_child(ui_layer)
