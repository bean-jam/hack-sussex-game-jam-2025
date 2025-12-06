extends Node

var game_length: float = 180.0
var consultation_fee: int = 2 

# --- PRICING CONFIG ---
# Since you are using Resources, you ideally want the price IN the resource.
# But for now, we can map the Item Name string to a price here.
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

# CHANGED: Now stores the actual Resource object, not a string
var current_target_item: Item = null 

func _ready():
	time_left = game_length
	
	SignalBus.customer_at_desk.connect(_on_customer_at_desk)
	SignalBus.attempt_delivery.connect(_check_delivery)
	SignalBus.rat_squished.connect(_on_rat_squished)
	
	# Careful with infinite loops! (removed self-connection for rat score)
	# SignalBus.rat_score_updated.connect(_on_rat_score_updated) 

# --- LOGIC ---

func _on_customer_at_desk(customer_data):
	# 'customer_data' should be the actual Customer node or a Dictionary
	# Assuming the customer emits their desired_item when they arrive
	if customer_data is Item:
		current_target_item = customer_data
		print("Manager: New order received for " + current_target_item.item_name)
	elif customer_data.has("desired_item"):
		current_target_item = customer_data.desired_item

func _check_delivery(held_item_resource):
	# If no customer is there (or they haven't ordered yet), ignore
	if current_target_item == null:
		return

	var success = false
	var item_name = "Unknown"
	
	if held_item_resource != null:
		item_name = held_item_resource.item_name # Assuming your Item resource has 'item_name'

	# LOGIC: Compare Resources
	if held_item_resource == current_target_item:
		success = true
		_add_money(item_name)
		current_target_item = null # Order filled
	else:
		success = false
		print("Manager: Wrong item! Wanted: " + current_target_item.item_name + ", Got: " + item_name)

	# Tell the Customer (and Spawner) the result
	SignalBus.delivery_result.emit(success)

func _add_money(item_name):
	var payout = consultation_fee
	
	if prices.has(item_name):
		payout += prices[item_name]
	
	score += payout
	print("Score: ", score)
	SignalBus.score_updated.emit(score)

# --- RAT LOGIC ---

func _on_rat_squished():
	score += 1
	rat_score += 1
	SignalBus.score_updated.emit(score)
	SignalBus.rat_score_updated.emit(rat_score)

func end_game():
	is_game_active = false
	SignalBus.day_ended.emit()
