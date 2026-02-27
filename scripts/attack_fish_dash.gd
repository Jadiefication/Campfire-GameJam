extends CharacterBody2D

@export var speed := 400
var player
var charge_direction := Vector2.ZERO

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	velocity = charge_direction * speed
	move_and_slide()
	
	for i in range (get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.is_in_group("player"):
			#TODO make it kill the player, or damage
			pass
		
		
			
