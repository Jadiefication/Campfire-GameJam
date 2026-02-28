extends Area2D
@export var attack_fish_dash: PackedScene
var fish_spawned: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	$AnimatedSprite2D.play("closed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if not fish_spawned and body.is_in_group("player"):
		spawn_fish.call_deferred(body)
func spawn_fish(player) -> void:
	if fish_spawned:
		return
	fish_spawned = true
	var direction = (player.global_position - global_position).normalized()
	var spawn_direction = Vector2.ZERO
	if abs(direction.x) > abs(direction.y):
		spawn_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		spawn_direction = Vector2.DOWN if direction.y > 0 else Vector2.UP

	$AnimatedSprite2D.play("open")
	print("spawn fish")
	var fish = attack_fish_dash.instantiate()
	fish.global_position = global_position + spawn_direction
	get_parent().add_child(fish)
	# TODO
	print("we got somewhere")

	#change sprite to a different one
