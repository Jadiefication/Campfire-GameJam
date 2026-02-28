extends Button

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/base.tscn")
	


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
