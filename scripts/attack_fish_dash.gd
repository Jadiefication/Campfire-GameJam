extends CharacterBody2D

@export var speed := 250
var player
var charge_direction = Vector2.ZERO
var is_active = true
func _ready():
	print("succeded")
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_warning("attack_fish_dash: No node found in group 'player'")
		is_active = false
		return

	var to_player = player.global_position - global_position
	charge_direction = to_player.normalized()

func _physics_process(delta):
	if not is_active:
		return
	velocity = charge_direction * speed
	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider and collider.is_in_group("player") and is_active:
			print("gotcha")
			stop_movement()
			# TODO make it kill the player, or damage

func stop_movement():
	charge_direction = Vector2.ZERO
	is_active = false
	velocity = Vector2.ZERO
	await get_tree().create_timer(1.0).timeout
	queue_free()
