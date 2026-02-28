extends Control

@onready var splash = $SplashOverlay
@onready var logo = $SplashOverlay/SplashLogo
@onready var splash_sound = $SplashSound

func _ready():
	# Wait 1.5 seconds
	splash_sound.play()
	await get_tree().create_timer(1.5).timeout

	# Create one tween and fade both at once
	var tween = create_tween()
	tween.tween_property(splash, "modulate:a", 0.0, 1.0)
	tween.tween_property(logo, "modulate:a", 0.0, 1.0)
	await tween.finished

	splash.visible = false