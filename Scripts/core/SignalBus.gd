extends Node

# --- CUSTOMER FLOW ---
# Emitted when the customer stops at the desk. 
# The UI listens to this to show the bubble.
signal customer_at_desk(customer_data) 

# Emitted when the player interacts with the customer to give an item.
# The Game Manager listens to this to check if the item matches the order.
signal attempt_delivery(held_item_name) 

# Emitted immediately after 'attempt_delivery' logic checks the order.
# The Customer listens to this to know if they should leave happy or angry.
signal delivery_result(was_successful) 

# --- INGREDIENTS & CRAFTING ---
# Emitted when an ingredient is dropped into the cauldron.
signal ingredient_added(ingredient_name)

# --- GAME STATE & RATS ---
# Emitted when a rat is clicked.
signal rat_squished

# Emitted whenever points are added/removed so the GUI updates.
signal score_updated(new_total_score)

# Emitted when the timer hits 0.
signal day_ended
