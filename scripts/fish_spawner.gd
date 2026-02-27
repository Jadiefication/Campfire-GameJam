extends Node2D
@export var attack_fish_dash: PackedScene
var fish_spawned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !fish_spawned:
		spawn_fish()
func spawn_fish() -> void:
	var fish = attack_fish_dash.instantiate
	fish.global_position = global_position
	get_parent().add_child(fish)
	# TODO
	fish_spawned = true
	#change sprite to a different one
	
	
