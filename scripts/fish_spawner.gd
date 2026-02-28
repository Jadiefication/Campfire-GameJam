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
	$AnimatedSprite2D.play("open")
	print("spawn fish")

	var fish = attack_fish_dash.instantiate()

	var direction = (player.global_position - global_position).normalized()
	var spawn_distance = 250
	fish.global_position = global_position + direction * spawn_distance

	get_parent().add_child(fish)

	print("we got somewhere")
	$Timer.start()
	#change sprite to a different one


func _on_timer_timeout() -> void:
	fish_spawned = false
	for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				spawn_fish.call_deferred(body)
				return  # only spawn one
