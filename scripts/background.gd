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
var active_bg = true

func _ready():
	# Load first background
	$BackgroundA.texture = load(backgrounds[current_index])
	$BackgroundB.modulate.a = 0.0 # invisible
	$Timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _on_Timer_timeout():
	# Prepare next background
	current_index += 1
	if current_index >= backgrounds.size():
		current_index = 0

	var fade_bg = $BackgroundB if active_bg else $BackgroundA
	var show_bg = $BackgroundA if active_bg else $BackgroundB

	fade_bg.texture = load(backgrounds[current_index])
	fade_bg.modulate.a = 0.0 # start transparent
# Animate fade
	fade_bg.animate_property("modulate:a", 1.0, transition_time)
	show_bg.animate_property("modulate:a", 0.0, transition_time)
	
	active_bg = not active_bg
