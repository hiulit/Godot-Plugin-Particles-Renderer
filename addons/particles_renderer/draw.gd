extends Node2D

var rect := Rect2() setget _set_rect


func _draw():
	draw_rect(rect, Color.black, false)


func _set_rect(new_value):
	rect = new_value
	update()
