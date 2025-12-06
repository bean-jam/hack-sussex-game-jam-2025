extends Node

var game_length: float = 180.0 # 3 minutes in seconds
var consultation_fee: int = 2   # Player recieves on contact with customer

## Add the actual potions and scores for creating them later
var prices = {
	"Love Potion": 50,
	"Yellow Fever": 20,
	"Tonic": 10,
	"Contraceptive": 30,
	"Rat Skewer": 5 # Maybe a cheap snack?
}

## State Variables
var score: int = 0
var time_left: float
var current_target_item: String = "" # What the customer currently waiting wants
var is_game_active: bool = true
var rat_score: int = 1

## Init function
func _ready():
	time_left = game_length
	
	# Connect to the SignalBus to listen for events
	SignalBus.customer_at_desk.connect(_on_customer_at_desk)
	SignalBus.attempt_delivery.connect(_check_delivery)
	SignalBus.rat_squished.connect(_on_rat_squished)


## What happens when a customer arrives?
func _on_customer_at_desk(data):
	pass
	

func _check_delivery(held_item_name):
	# If no customer is there, ignore
	if current_target_item == "":
		return

	var success = false
	
	# LOGIC: Did we give them what they asked for?
	if held_item_name == current_target_item:
		success = true
		_add_money(held_item_name)
	else:
		success = false
		# Optional: Penalty for wrong item?
		print("Wrong item! Wanted: " + current_target_item + ", Got: " + str(held_item_name))

	# Tell the Customer (and UI) the result
	SignalBus.delivery_result.emit(success)
	
	if success:
		# Clear the order so we don't pay twice
		current_target_item = ""

## Add points to the score per rat squished
func _on_rat_squished():
	# Simple bonus points
	score += 1
	rat_score += 1
	SignalBus.score_updated.emit(score) # Emits total score
	SignalBus.rat_score_updated.emit(rat_score) # Emits total rat_score
	
func _add_money(item_name):
	var payout = consultation_fee
	
	if prices.has(item_name):
		payout += prices[item_name]
	
	score += payout
	SignalBus.score_updated.emit(score)
	
func end_game():
	is_game_active = false
	SignalBus.day_ended.emit()
	print("Day Over! Final Score: " + str(score))
