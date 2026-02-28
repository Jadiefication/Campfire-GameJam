extends CharacterBody2D

@export var speed := 80
var player: Node2D
var is_active := true
var can_damage := false

func _ready():
	# Set correct layers/masks
	collision_layer = 2
	collision_mask = 1

	add_to_group("zombie") # useful for debugging

	player = get_tree().get_first_node_in_group("player")
	await get_tree().physics_frame
	can_damage = true

func _physics_process(delta):
	if not is_active:
		return

	if player:
		var to_player = player.global_position - global_position
		if to_player.length() > 0.01:
			velocity = to_player.normalized() * speed
		else:
			velocity = Vector2.ZERO

	move_and_slide()

	if not can_damage:
		return

	for i in range(get_slide_collision_count()):
		var col = get_slide_collision(i)
		var collider = col.get_collider()
		if collider and collider.is_in_group("player"):
			# damage and short stun
			if Engine.has_singleton("Global"): # optional check
				if "Global" in ProjectSettings.globalize_path("res://"): pass
				
			Global.hp -= 10
			await wait_after_hit()
			break

func wait_after_hit():
	is_active = false
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.5).timeout
	is_active = true