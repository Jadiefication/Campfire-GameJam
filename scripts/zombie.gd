extends CharacterBody2D

@export var speed := 100
var player: Node2D
var is_active := false
var can_damage := false

func _ready():

	add_to_group("zombie") # useful for debugging

	# Connect signals from the Area2D nodes
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)
	
	$hitbox.body_entered.connect(_on_hitbox_body_entered)
	$AnimatedSprite2D.play("swimming")

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

func _on_hitbox_body_entered(body: Node2D) -> void:
	if not can_damage:
		return
	if body.is_in_group("player"):
		# damage and short stun
		Global.hp -= 10
		$AudioStreamPlayer2D.play()
		wait_after_hit()

func _physics_process(delta):
	if not is_active:
		return

	if player:
		var to_player = player.global_position - global_position
		$AnimatedSprite2D.play("swimming")
		# Flip horizontally based on the player's position relative to the zombie
		if to_player.x < 0:
			$AnimatedSprite2D.flip_h = false  # Player is to the left
		elif to_player.x > 0:
			$AnimatedSprite2D.flip_h = true   # Player is to the right

		if to_player.length() > 0.01:
			velocity = to_player.normalized() * speed
		else:
			velocity = Vector2.ZERO

	move_and_slide()

func wait_after_hit():
	is_active = false
	velocity = Vector2.ZERO
	get_tree().create_timer(0.5).timeout.connect(func(): 
		if player: # Only reactivate if player is still in the detection area
			is_active = true
	)
