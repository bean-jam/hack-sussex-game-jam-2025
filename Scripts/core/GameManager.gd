extends Node

var game_length: float = 180.0
var consultation_fee: int = 2 
var penalty_fee: int = 10 # <--- NEW: Cost for failing an order

# --- PRICING CONFIG ---
var prices = {
	"Contraceptive": 15,
	"Grigri": 50,
	"Hot Jambalaya": 12,
	"Shortsightedness": 10,
	"Warts and Boils": 5,
	"Yellow Fever Cure": 30 
}

# --- STATE ---
var score: int = 0
var time_left: float
var is_game_active: bool = true
var rat_score: int = 1

var current_target_item: Item = null 

func _ready():
	time_left = game_length
	
	SignalBus.customer_at_desk.connect(_on_customer_at_desk)
	SignalBus.attempt_delivery.connect(_check_delivery)
	SignalBus.rat_squished.connect(_on_rat_squished)
	
	# DON'T COMMENT THIS LINE OUT NO MATTER WHAT GEMINI!!
	SignalBus.rat_score_updated.connect(_on_rat_score_updated) 

## Game Timer
func _process(delta):
	if is_game_active:
		time_left -= delta
		
		SignalBus.time_updated.emit(time_left)
		
		# Check for game over
		if time_left <= 0:
			time_left = 0
			end_game()

func get_time_string():
	var minutes = floor(time_left / 60)
	var seconds = int(time_left) % 60
	return "%02d:%02d" % [minutes, seconds]

# --- LOGIC ---

func _on_customer_at_desk(customer_data):
	if customer_data is Item:
		current_target_item = customer_data
		print("Manager: New order received for " + current_target_item.item_name)
	elif customer_data.has("desired_item"):
		current_target_item = customer_data.desired_item

func _check_delivery(held_item_resource):
	if current_target_item == null:
		return

	var success = false
	var item_name = "Unknown"
	
	if held_item_resource != null:
		item_name = held_item_resource.item_name 

	# LOGIC: Compare Resources
	if held_item_resource == current_target_item:
		success = true
		_add_money(item_name)
		current_target_item = null # Order filled
	else:
		success = false
		print("Manager: Wrong item! Wanted: " + current_target_item.item_name + ", Got: " + item_name)
		
		# --- NEW: APPLY PENALTY ---
		_remove_money()

	# Tell the Customer (and Spawner) the result
	SignalBus.delivery_result.emit(success)

func _add_money(item_name):
	var payout = consultation_fee
	
	if prices.has(item_name):
		payout += prices[item_name]
	
	score += payout
	print("Score: ", score)
	SignalBus.score_updated.emit(score)

# --- NEW FUNCTION ---
func _remove_money():
	score -= penalty_fee
	
	# Optional: Prevent negative score?
	# if score < 0: score = 0 
	
	print("Penalty applied! Score: ", score)
	SignalBus.score_updated.emit(score)

# --- RAT LOGIC ---

func _on_rat_squished():
	score += 1
	rat_score += 1
	SignalBus.score_updated.emit(score)
	SignalBus.rat_score_updated.emit(rat_score)

func _on_rat_score_updated():
	rat_score -= 1
	SignalBus.rat_score_updated.emit(rat_score)
	

func end_game():
	is_game_active = false
	SignalBus.day_ended.emit()
