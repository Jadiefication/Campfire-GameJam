extends CharacterBody2D

@export var speed := 250
var player
var charge_direction = Vector2.ZERO
var is_active = true
func _ready():
	print("succeded")
	player = get_tree().get_first_node_in_group("player")
	var to_player = player.global_position - global_position
	charge_direction = to_player.normalized()

func _physics_process(delta):
	if not is_active:
		return
	velocity = charge_direction * speed
	move_and_slide()
	
	for i in range (get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.is_in_group("player") and is_active:
			stop_movement()
			print("gotcha")
			#TODO make it kill the player, or damage
func stop_movement():
	charge_direction = Vector2.ZERO
	is_active = false
	get_tree().create_timer(1)
	queue_free()
		
		
			
