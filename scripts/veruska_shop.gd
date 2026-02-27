extends Area2D

@export var popup_path : NodePath
var popup
var player_is_in_area: bool = false
func _ready():
	popup = get_node(popup_path)
	popup.visible = false 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_is_in_area and Input.is_action_just_pressed("Interact"):
		#TODO make shop ui popup
		pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		popup.visible = true
		player_is_in_area = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		popup.visible = false
		player_is_in_area = false
