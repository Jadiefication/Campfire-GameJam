extends Button


func _on_pressed() -> void:
	get_parent().get_node("ButtonSound").play()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
