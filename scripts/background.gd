extends TextureRect

var backgrounds = [
	preload("res://IMGS/day.jpg"),
	preload("res://IMGS/eve.jpg"),
	preload("res://IMGS/nigg.jpg"),
	preload("res://IMGS/mor.jpeg")
]

@export var transition_time := 1.5
var index := 0

func _ready():
	texture = backgrounds[index]
	modulate.a = 1.0
	$Timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	# fade out
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, transition_time)

	await tween.finished

	# change texture
	index = (index + 1) % backgrounds.size()
	texture = backgrounds[index]

	# fade in
	var tween_in = create_tween()
	tween_in.tween_property(self, "modulate:a", 1.0, transition_time)