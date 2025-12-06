extends Label

func _ready():
	# Connect to the dedicated rat score signal
	SignalBus.rat_score_updated.connect(_on_rat_score_updated)

func _on_rat_score_updated(new_rat_score: int):
	self.text = str(new_rat_score)
