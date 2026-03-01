extends Node2D

# List your background images
var backgrounds = [
	preload("res://IMGS/day.jpg"),
	preload("res://IMGS/eve.jpg"),
	preload("res://IMGS/nigg.jpg"),
	preload("res://IMGS/mor.jpeg")
]

var save_path := "user://leaderboard.save"

func save_run():
	var file = File.new()
	var scores = []

	# Load existing scores if the file exists
	if file.file_exists(save_path):
		if file.open(save_path, File.READ) == OK:
			scores = file.get_var()
			file.close()

	# Add the current run
	scores.append(Global.total_money)

	# Optionally, keep the list sorted descending
	scores.sort_custom(self, "_sort_descending")

	# Save updated scores
	if file.open(save_path, File.WRITE) == OK:
		file.store_var(scores)
		file.close()

# Custom sort function for descending order
func _sort_descending(a, b):
	return b - a

func load_leaderboard():
	var file = File.new()
	if file.file_exists(save_path):
		if file.open(save_path, File.READ) == OK:
			var scores = file.get_var()
			file.close()
			return scores
	return []

@export var transition_time := 1.5
var index := 0
var showing_a := true  # which TextureRect is currently visible

func _ready():
	$Background.texture = backgrounds[index]
	$Background.modulate.a = 1.0
	$Backgg.modulate.a = 0.0
	$Timer.timeout.connect(_on_timer_timeout)
	get_tree().about_to_quit.connect(save_run)

func _on_timer_timeout():
	# move to the next image in order
	index = (index + 1) % backgrounds.size()

	# pick which TextureRect fades in/out
	var fade_in = $Backgg if showing_a else $Background
	var fade_out = $Background if showing_a else $Backgg

	# assign next texture to fade_in
	fade_in.texture = backgrounds[index]
	fade_in.modulate.a = 0.0

	# create tween: fade out old, fade in new simultaneously
	var tween = create_tween()
	tween.tween_property(fade_out, "modulate:a", 0.0, transition_time)
	tween.parallel().tween_property(fade_in, "modulate:a", 1.0, transition_time)

	# toggle which TextureRect is active
	showing_a = !showing_a
