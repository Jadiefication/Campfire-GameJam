extends CharacterBody2D

# --- EXPORT VARIABLES ---
@export var speed: float = 200.0
@export var rope_length: float = 500.0

# --- NODE REFERENCES ---
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var bubbles_node = get_parent().get_node("Bubbles")
@onready var rope_line = get_parent().get_node("PinJoint2D/Line2D")
@onready var hook = get_parent().get_node("oxygen_tank")

# --- INTERNAL VARIABLES ---
var rope_active: bool = false
var hook_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Initialize hook position and turn on the rope
	if hook:
		hook_position = hook.global_position
		rope_active = true
	
	# Connect the signal for the "one-shot" animation reset
	sprite.animation_finished.connect(_on_animation_finished)
	
	# Start in a clean state
	sprite.play("Idle")

func _physics_process(_delta: float) -> void:
	var input_dir = Vector2.ZERO

	# 1. HANDLE INPUT
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.y = Input.get_axis("move_up", "move_down")
	
	# 2. HANDLE VELOCITY & ANIMATIONS
	if input_dir != Vector2.ZERO:
		velocity = input_dir.normalized() * speed
		
		# Only play Walk if we aren't already walking
		if sprite.animation != "Walk":
			sprite.play("Walk")
		
		# Flip sprite based on direction
		if input_dir.x != 0:
			sprite.flip_h = input_dir.x < 0
	else:
		velocity = Vector2.ZERO
		
		# If we WERE walking but just stopped, trigger the one-shot Idle
		if sprite.animation == "Walk":
			sprite.play("Idle")

	# 3. ROPE PHYSICS CONSTRAINT
	if rope_active:
		var to_player = global_position - hook_position
		var dist = to_player.length()

		if dist > rope_length and dist != 0:
			var direction = to_player / dist
			var excess = dist - rope_length
			# Pull player back to the rope's limit
			global_position -= direction * excess
			# Prevent movement from fighting the rope
			var tangent = Vector2(-direction.y, direction.x)
			velocity = velocity.project(tangent)

	# 4. EXECUTE MOVEMENT
	move_and_slide()

	# 5. UPDATE ROPE VISUALS
	if rope_active and rope_line:
		update_rope_visuals()

# --- HELPER FUNCTIONS ---

func update_rope_visuals() -> void:
	var segments = clamp(int(rope_length / 5), 2, 50)
	var points = []
	for i in range(segments + 1):
		var t = float(i) / segments
		var point = hook_position.lerp(global_position, t)
		points.append(rope_line.to_local(point))
	rope_line.points = points

func _on_animation_finished() -> void:
	# If Idle finishes (and it's NOT set to loop), clear the animation
	if sprite.animation == "Idle":
		sprite.stop()
		sprite.animation = &"None" # Resets to a non-existent/empty state

# --- WATER TRANSITION LOGIC ---

func on_enter_water(body: Node2D) -> void:
	if body == self and bubbles_node:
		bubbles_node.visible = true
		var mat = bubbles_node.get_node("ColorRect").material
		var tween = create_tween()
		
		# Bubble splash in
		tween.tween_property(mat, "shader_parameter/transition_fill", 1.5, 0.6).set_trans(Tween.TRANS_SINE)
		tween.tween_interval(1.0)
		# Bubble clear out
		tween.tween_property(mat, "shader_parameter/transition_fill", 0.0, 0.6).set_trans(Tween.TRANS_SINE)
		tween.tween_callback(func(): bubbles_node.visible = false)

		# Underwater Text Display
		var underwater_text = get_parent().get_node("Underwater_Text") as TextureRect
		if underwater_text:
			show_underwater_text(underwater_text)

func show_underwater_text(txt_rect: TextureRect) -> void:
	txt_rect.modulate.a = 0.0
	txt_rect.visible = true
	await get_tree().create_timer(1.5).timeout
	await fade_texture(txt_rect, 1.0, 1.0)
	await get_tree().create_timer(1.0).timeout
	await fade_texture(txt_rect, 0.0, 1.0)
	txt_rect.visible = false

func fade_texture(texture_rect: TextureRect, target_alpha: float, duration: float) -> void:
	var tween = create_tween()
	await tween.tween_property(texture_rect, "modulate:a", target_alpha, duration).finished