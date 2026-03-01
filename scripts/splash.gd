extends Control

# --- NODE REFERENCES ---
@onready var splash = $SplashOverlay
@onready var logo = $SplashOverlay/SplashLogo
@onready var splash_sound = $SplashSound
@onready var music = $Music
@onready var leaderboard = $Leaderboard
@onready var leaderboard_label = $Leaderboard/Label

# --- SAVE PATH ---
var save_path := "user://leaderboard.save"

# --- FUNCTIONS ---

func load_leaderboard() -> Array:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var scores = file.get_var()
			file.close()
			return scores
	return []

func _ready() -> void:
	# --- Splash Sequence ---
	splash_sound.play()
	await get_tree().create_timer(1.5).timeout

	var tween = create_tween()
	tween.tween_property(splash, "modulate:a", 0.0, 1.0)
	tween.tween_property(logo, "modulate:a", 0.0, 1.0)
	await tween.finished

	splash.visible = false
	music.play()

	# --- Leaderboard Logic ---
	if Global.show_leaderboard:
		var scores = load_leaderboard()
		if scores.size() > 0:
			leaderboard.visible = true
			
			# Format the top 5 scores
			var display_text = "LEADERBOARD\n"
			var limit = min(scores.size(), 5)
			for i in range(limit):
				display_text += str(i + 1) + ". $" + str(scores[i]) + "\n"
			
			leaderboard_label.text = display_text
		else:
			leaderboard.visible = false  # hide if empty
		Global.show_leaderboard = false
