extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var timer_label = $TimerLabel

func _ready():
	# 1. Update Score immediately (start at $0)
	score_label.text = "Score: $0"
	
	# 2. Listen for score changes
	SignalBus.score_updated.connect(_on_score_updated)

func _process(delta):
	# 3. Update Timer every frame
	# We pull directly from GameManager since it changes constantly
	if GameManager.is_game_active:
		timer_label.text = GameManager.get_time_string()
	else:
		timer_label.text = "00:00"

func _on_score_updated(new_score):
	# Update the text whenever the score changes
	score_label.text = "Score: $" + str(new_score)
