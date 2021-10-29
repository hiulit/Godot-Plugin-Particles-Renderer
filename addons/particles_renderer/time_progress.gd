extends Control

var time := 2.0
var timer := 0.0

onready var texture_progress := $TextureProgress


func _ready():
	texture_progress.max_value = time
	texture_progress.step = 0.01


func _process(delta):
	timer += delta

	texture_progress.value = timer

	if timer > time:
		set_process(false)
