extends Control

func _ready():
	# 1. Display the final score from the Manager
	$Content/ScoreLabel.text = "Total Earnings: $" + str(GameManager.score)
	
	# 2. Connect the button
	$Content/MenuButton.pressed.connect(_on_menu_pressed)

func _on_menu_pressed():
	# Reset the game variables so next time isn't broken
	GameManager.reset_game()
	
	# Load the Main Menu (Change path to match your file!)
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
