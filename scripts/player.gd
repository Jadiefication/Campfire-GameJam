extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get direction: -1 (left), 1 (right), or 0 (none)
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = (direction < 0) # Flip sprite when going left
		
		# Only play "Run" if you've created it in the AnimatedSprite2D
		if sprite.sprite_frames.has_animation("Run"):
			sprite.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("Idle")

	move_and_slide()