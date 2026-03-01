extends TextureRect

func _ready() -> void:
	Global.money_changed.connect(_on_money_changed)
	$Label.text = "$" + str(Global.money)

func _on_money_changed(new_money: int) -> void:
	$Label.text = "$" + str(new_money)