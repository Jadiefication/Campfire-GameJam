extends Area2D



var player_is_in_area: bool = false
var popup
@onready var shop_items = $CanvasLayer/ItemList
var is_shopping = false
var hp_upgrade_cost: int = 500

func _ready() -> void:
	popup = $Label
	popup.visible = false
	# Initialize the ItemList text with the initial price
	shop_items.set_item_text(0, "HP - $" + str(hp_upgrade_cost))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_is_in_area and Input.is_action_just_pressed("Interact") and !is_shopping:
		# Center the shop items in the player's view
		shop_items.visible = true
		is_shopping = true
	elif player_is_in_area and Input.is_action_just_pressed("Interact") and is_shopping:
		shop_items.visible = false
		is_shopping = false
	
	# Since ItemList is now in a CanvasLayer and has anchors_preset = 8 (Center),
	# it will be automatically centered on the screen by Godot.
	# We no longer need manual world-to-screen coordinate math.
	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		popup.visible = true
		player_is_in_area = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		popup.visible = false
		player_is_in_area = false


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if index == 0:
		if Global.money >= hp_upgrade_cost:
			Global.money -= hp_upgrade_cost
			Global.max_hp += 20
			# Increase the cost for the next upgrade
			hp_upgrade_cost += 500
			# Update the UI text
			shop_items.set_item_text(0, "HP - $" + str(hp_upgrade_cost))
			print(Global.max_hp)
		else:
			print("Not enough money!")
	elif index == 1:
		pass
	
