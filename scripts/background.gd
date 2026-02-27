extends TextureRect

# List of background textures
var backgrounds = [
preload("res://IMGS/day.jpg"),
preload("res://IMGS/eve.jpg"),
preload("res://IMGS/nigg.jpg"),
preload("res://IMGS/mor.jpeg")
]
@export var transition_time: float = 1.5 # seconds for fade

var current_index = 0
var active_bg = true # true = BackgroundA visible, false = BackgroundB visible

func _ready():
# Load the first background
	$day.texture = load(backgrounds[current_index])
	$eve.modulate.a = 0.0 # invisible
	$Timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _on_Timer_timeout():
# Advance to next background
	current_index += 1
	if current_index >= backgrounds.size():
		current_index = 0

# Determine which TextureRect is fading in/out
	var fade_bg = $eve if active_bg else $day
	var show_bg = $day if active_bg else $eve

# Load new background to fade in
	fade_bg.texture = load(backgrounds[current_index])
	fade_bg.modulate.a = 0.0

# Animate fade
	fade_bg.animate_property("modulate:a", 1.0, transition_time)
	show_bg.animate_property("modulate:a", 0.0, transition_time)

# Swap active background
	active_bg = not active_bg