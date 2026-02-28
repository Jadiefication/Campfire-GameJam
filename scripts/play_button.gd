extends Button

@onready var splash = get_parent().get_node("SplashOverlay")
@onready var logo = splash.get_node("SplashLogo")

func _on_pressed() -> void:
	await transition_to_scene("res://scenes/base.tscn")

func _on_credits_pressed() -> void:
	await transition_to_scene("res://scenes/credits.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func transition_to_scene(scene_path: String) -> void:
	# Reuse same overlay + logo
	splash.visible = true
	logo.visible = true

	splash.modulate.a = 0.0
	logo.modulate.a = 1.0  # logo stays visible

	var tween = create_tween()
	tween.tween_property(splash, "modulate:a", 1.0, 1.0) # fade overlay in
	tween.tween_property(logo, "modulate:a", 0.0, 1.0)   # fade logo out if desired
	await tween.finished

	get_tree().change_scene_to_file(scene_path)
