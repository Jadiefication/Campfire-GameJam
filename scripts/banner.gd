extends TextureRect

func _ready() -> void:
	$Label.text = "$" + str(Global.money)