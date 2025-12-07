extends Control

# Path to your actual game scene
# Drag your Main.tscn (or Level1.tscn) from FileSystem into this variable property
@export var game_scene: PackedScene

@onready var instructions_panel = $InstructionsPanel

func _ready():
	# Ensure instructions are hidden at start
	instructions_panel.visible = false
	
	# Connect buttons via code (or use the Inspector Signals tab)
	$MenuButtons/PlayButton.pressed.connect(_on_play_pressed)
	$MenuButtons/InstructionsButton.pressed.connect(_on_instructions_pressed)
	$MenuButtons/QuitButton.pressed.connect(_on_quit_pressed)
	
	# Instructions back button
	$InstructionsPanel/BackButton.pressed.connect(_on_back_pressed)

func _on_play_pressed():
	if game_scene:
		get_tree().change_scene_to_packed(game_scene)
	else:
		print("ERROR: No Game Scene assigned in Main Menu Inspector!")

func _on_instructions_pressed():
	instructions_panel.visible = true
	$MenuButtons.visible = false # Hide buttons so they can't be clicked

func _on_back_pressed():
	instructions_panel.visible = false
	$MenuButtons.visible = true

func _on_quit_pressed():
	get_tree().quit()
