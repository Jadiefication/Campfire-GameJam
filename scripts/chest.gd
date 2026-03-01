extends Area2D
var player_is_in_area: bool = false
var popup
@export var min_money:int
@export var max_money:int
var claimed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	popup = $Label
	popup.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_is_in_area and Input.is_action_just_pressed("Interact") and !claimed:
		Global.money += randi_range(min_money, max_money)
		$AnimatedSprite2D.play("open")
		print("chest opened")
		claimed = true
		$Timer.start()
		


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		popup.visible = true
		player_is_in_area = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		popup.visible = false
		player_is_in_area = false


func _on_timer_timeout() -> void:
	claimed = false
	$AnimatedSprite2D.play("closed")
