extends CharacterBody2D

# --- EXPORT VARIABLES ---
@export var speed: float = 200.0
@export var rope_length: float = 500.0

@export var hp: Array[AtlasTexture]

# --- CONSTANTS ---
var GRAVITY: float = 1200.0
const JUMP_VELOCITY: float = -600

var hp_current = 100

# --- NODE REFERENCES ---
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var bubbles_node = get_parent().get_node("Bubbles")
@onready var rope_line = get_parent().get_node("PinJoint2D/Line2D")
@onready var hook = get_parent().get_node("oxygen_tank")

# --- INTERNAL VARIABLES ---
var rope_active: bool = false
var hook_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	Global.money_changed.connect(change_money)
	if hook:
		hook_position = hook.global_position
		rope_active = true

	sprite.animation_finished.connect(_on_animation_finished)
	sprite.play("Idle")
	
	if get_parent().name == "World1":
		GRAVITY /= 2
		speed /= 2
	
func change_money(money):
	if get_node_or_null("Camera2D") != null:
		$Camera2D.get_node("Banner/Label").text = "$" + str(money)
	else:
		get_parent().get_node("Banner/Label").text = "$" + str(money)

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")

	# --- UPDATE HOOK POSITION ---
	if hook:
		hook_position = hook.global_position

	# --- GRAVITY ---
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.y = 0
		
	if Input.is_key_pressed(Key.KEY_ESCAPE):
		change_scenes("res://scenes/main_menu.tscn")

	# --- JUMP ---
	if Input.is_key_pressed(Key.KEY_SPACE):	
	
		# Only jump if on floor
		if is_on_floor():
			if direction == 0:
				# Simple vertical jump
				velocity.y = JUMP_VELOCITY
				sprite.play("Jump")
			else:
				# Diagonal jump
				velocity.y = JUMP_VELOCITY
				velocity.x = velocity.x * speed
				sprite.play("Jump")

	# --- HORIZONTAL MOVEMENT ---
	if direction != 0:
		velocity.x = direction * speed
		if sprite.animation != "Walk":
			sprite.play("Walk")
		sprite.flip_h = direction < 0
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.1)
		if sprite.animation == "Walk":
			sprite.play("Idle")
			
	if get_parent().name == "World1":
		if Input.is_key_pressed(Key.KEY_W):
			velocity.y = JUMP_VELOCITY / 4
		if Input.is_key_pressed(Key.KEY_S):
			velocity.y = -JUMP_VELOCITY / 4
		if Input.is_key_pressed(Key.KEY_R):
			change_scenes("res://scenes/base.tscn")

	# --- ROPE CONSTRAINT --- 
	if rope_active:
		var to_player = global_position - hook_position
		var dist = to_player.length()

		if dist > rope_length and dist != 0:
			var dir = to_player / dist
			var excess = dist - rope_length
			global_position -= dir * excess

			var tangent = Vector2(-dir.y, dir.x)
			velocity = velocity.project(tangent)

	move_and_slide()

	# --- ROPE VISUAL ---
	if rope_active and rope_line:
		update_rope_visuals()

# ---------------- HELPERS ----------------

func update_rope_visuals() -> void:
	var segments = clamp(int(rope_length / 5), 2, 50)
	var points = []
	for i in range(segments + 1):
		var t = float(i) / segments
		var point = hook_position.lerp(global_position, t)
		points.append(rope_line.to_local(point))
	rope_line.points = points

func _on_animation_finished() -> void:
	sprite.stop()
	sprite.animation = &"None"

# --- WATER TRANSITION LOGIC ---

func on_enter_water(body: Node2D) -> void:
	if body == self and bubbles_node:
		change_scenes("res://scenes/mapa_pls.tscn")
		
func change_scenes(new_scene: String):
	bubbles_node.visible = true
	var mat = bubbles_node.get_node("ColorRect").material
	get_parent().get_node("BubbleSFX").play()
	var tween = create_tween()
			
	tween.tween_property(mat, "shader_parameter/transition_fill", 1.5, 0.6).set_trans(Tween.TRANS_SINE)
	tween.tween_interval(1.0)
	tween.tween_property(mat, "shader_parameter/transition_fill", 0.0, 0.6).set_trans(Tween.TRANS_SINE)
			
	tween.tween_callback(func(): 
		bubbles_node.visible = false
		get_tree().change_scene_to_file(new_scene)
	)
