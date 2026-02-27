extends CharacterBody2D

@export var speed = 200
@onready var bubbles_node = get_parent().get_node("Bubbles")

func _physics_process(delta):
	velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	velocity = velocity.normalized() * speed
	move_and_slide()

func on_enter_water(body: Node2D) -> void:
	# Ensure it's the player and we have a reference to the bubbles
	if body == self and bubbles_node:
		# 1. Make sure bubbles are visible (at 0.0 fill, they are transparent)
		bubbles_node.visible = true
		
		# 2. Get the shader material
		# Assuming the shader is on the root of the Bubbles scene or a ColorRect inside it
		var mat = bubbles_node.get_node("ColorRect").material

		# 3. Create the "Splash In" animation
		var tween = create_tween()
		
		# Animate transition_fill from 0.0 to 1.5 (Full bubble coverage)
		tween.tween_property(mat, "shader_parameter/transition_fill", 1.5, 0.6)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_OUT)
		
		# 4. Wait for 1 second (your original delay)
		tween.tween_interval(1.0)
		
		# 5. Create the "Back to Normal" animation
		tween.tween_property(mat, "shader_parameter/transition_fill", 0.0, 0.6)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN)
			
		# Optional: Hide node once transition is fully done to save performance
		tween.tween_callback(func(): bubbles_node.visible = false)
		
