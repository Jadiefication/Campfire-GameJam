extends Node2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Music.play()
	var underwater_text = $Player/Camera2D/Underwater_Text as TextureRect
	if underwater_text:
		show_underwater_text(underwater_text)
		
func show_underwater_text(txt_rect: TextureRect) -> void:
	txt_rect.modulate.a = 0.0
	txt_rect.visible = true
	await get_tree().create_timer(1.5).timeout
	await fade_texture(txt_rect, 1.0, 1.0)
	await get_tree().create_timer(1.0).timeout
	await fade_texture(txt_rect, 0.0, 1.0)
	txt_rect.visible = false
	
func fade_texture(texture_rect: TextureRect, target_alpha: float, duration: float) -> void:
	var tween = create_tween()
	await tween.tween_property(texture_rect, "modulate:a", target_alpha, duration).finished
