extends CharacterBody2D

@export var speed := 80
var player: Node2D
var is_active := false
var can_damage := false

func _ready():
	# Set correct layers/masks
	collision_layer = 2
	collision_mask = 1

	add_to_group("zombie") # useful for debugging

	# Connect signals from the Area2D node
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)

	await get_tree().physics_frame
	can_damage = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		is_active = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		is_active = false

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
			Global.hp -= 10
			wait_after_hit()
			break

func wait_after_hit():
	is_active = false
	velocity = Vector2.ZERO
	get_tree().create_timer(0.5).timeout.connect(func(): 
		if player: # Only reactivate if player is still in the detection area
			is_active = true
	)
