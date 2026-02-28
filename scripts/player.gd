extends CharacterBody2D

@export var speed = 200
@export var rope_length := 100.0  # this will control rope segment count dynamically
@onready var bubbles_node = get_parent().get_node("Bubbles")

var rope_active = false
var hook_position = Vector2.ZERO

@onready var rope_line = get_parent().get_node("PinJoint2D/Line2D")
@onready var hook = get_parent().get_node("oxygen_tank")

func _ready() -> void:
	hook_position = hook.global_position
	rope_active = true

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
		
	if rope_active:
		var to_player = global_position - hook_position
		var dist = to_player.length()
	
		if dist > rope_length:
			global_position = hook_position + to_player.normalized() * rope_length
			var tangent = Vector2(-to_player.y, to_player.x).normalized()
			velocity = velocity.project(tangent)

	velocity = velocity.normalized() * speed
	move_and_slide()
	
func _process(delta: float) -> void:
	if rope_active:
		# Determine number of segments based on radius
		var segments = clamp(int(rope_length / 5), 2, 50)  # adjust divisor to control density
		update_rope(segments)

func update_rope(new_points: int):
	var points = []
	for i in range(new_points + 1):
		var t = float(i) / new_points
		var point = hook_position.lerp(global_position, t)
		points.append(rope_line.to_local(point))  # convert to Line2D local
	rope_line.points = points
	
func fade_texture(texture_rect: TextureRect, target_alpha: float, duration: float) -> void:
	var start_alpha = texture_rect.modulate.a
	var timer := 0.0
	
	while timer < duration:
		timer += get_process_delta_time()
		var t = timer / duration
		# Smoothstep easing for nicer transition
		var alpha = lerp(start_alpha, target_alpha, t * t * (3.0 - 2.0 * t))
		texture_rect.modulate.a = alpha
		await get_tree().process_frame

	texture_rect.modulate.a = target_alpha  # ensure exact final alpha

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
		

		var underwater_text = get_parent().get_node("Underwater_Text") as TextureRect
		
		# Start hidden
		underwater_text.modulate.a = 0.0
		underwater_text.visible = true
		
		# Wait 1 second BEFORE showing
		await get_tree().create_timer(1.5).timeout
		
		# Fade in
		await fade_texture(underwater_text, 1.0, 1.0)
		
		# Stay visible for 1 second
		await get_tree().create_timer(1).timeout
		
		# Fade out
		await fade_texture(underwater_text, 0.0, 1.0)
		
		underwater_text.visible = false
		
		
