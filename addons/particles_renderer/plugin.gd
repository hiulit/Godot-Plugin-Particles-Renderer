tool
extends EditorPlugin

var menu_button


func _enter_tree():
	menu_button = preload("res://addons/particles_renderer/menu_button.tscn").instance()
	add_tool_menu_item("Particles Renderer", self, "_on_menu_button_pressed")


func _exit_tree():
	if menu_button:
		remove_tool_menu_item("Particles Renderer")
		menu_button.free()


func _on_menu_button_pressed(ud):
	get_editor_interface().play_custom_scene(
		"res://addons/particles_renderer/particles_renderer_window.tscn"
	)
