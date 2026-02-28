extends CharacterBody2D

@export var speed := 100
var player
var is_active = true

func _ready():
	# Pre-fetch the player so we don't have to call get_first_node every frame
	player = get_tree().get_first_node_in_group("player")
	print("Enemy initialized")

func _physics_process(_delta):
	if not is_active:
		return

	if player:
		var to_player = player.global_position - global_position
		velocity = to_player.normalized() * speed
	
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.is_in_group("player"):
			print("Gotcha!")
			wait_after_hit()
			

func wait_after_hit():
	is_active = false
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.5).timeout
	is_active = true
