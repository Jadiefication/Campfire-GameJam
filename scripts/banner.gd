extends TextureRect

func _ready() -> void:
	Global.money_changed.connect(_on_money_changed)
	Global.time_changed.connect(_on_time_changed)
	$Label.text = "$" + str(Global.money)
	_update_timer_label(Global.game_time)

func _on_money_changed(new_money: int) -> void:
	$Label.text = "$" + str(new_money)

func _on_time_changed(new_time: float) -> void:
	_update_timer_label(new_time)

func _update_timer_label(time: float) -> void:
	var minutes: int = int(time) / 60
	var seconds: int = int(time) % 60
	if get_node_or_null("TimerLabel"):
		$TimerLabel.text = "%02d:%02d" % [minutes, seconds]
