extends TextureRect

# List of background textures
var backgrounds = [
preload("res://IMGS/day.jpg"),
preload("res://IMGS/eve.jpg"),
preload("res://IMGS/nigg.jpg"),
preload("res://IMGS/mor.jpeg")
]

var current_index = 0

func _ready():
	self.texture = backgrounds[current_index]
	$Timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

func _on_Timer_timeout():
# Change to the next background
	current_index += 1
	if current_index >= backgrounds.size():
		current_index = 0
	self.texture = backgrounds[current_index]
