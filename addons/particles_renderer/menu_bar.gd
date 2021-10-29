extends Control

var menu_popup_file
var menu_popup_help

onready var file_dialog := $OpenFileFileDialog
onready var menu_button_file := $VBoxContainer/HBoxContainer/MenuButtonFile
onready var menu_button_help := $VBoxContainer/HBoxContainer/MenuButtonHelp
onready var window_dialog_about := $WindowDialogAbout


func _ready():
	menu_button_file.set_focus_mode(0)
	menu_button_help.set_focus_mode(0)

	menu_popup_file = menu_button_file.get_popup()
	menu_popup_file.add_item("Open File")
	menu_popup_file.add_item("Quit")
	menu_popup_file.connect("id_pressed", self, "_on_menu_popup_file_item_pressed")

	menu_popup_help = menu_button_help.get_popup()
	menu_popup_help.add_item("Documentation (online)")
	menu_popup_help.add_item("About")
	menu_popup_help.connect("id_pressed", self, "_on_menu_popup_help_item_pressed")


func _on_menu_popup_file_item_pressed(id):
	var item_name = menu_popup_file.get_item_text(id)

	match item_name:
		"Open File":
			file_dialog.popup_centered_ratio(0.5)
		"Quit":
			get_tree().quit()


func _on_menu_popup_help_item_pressed(id):
	var item_name = menu_popup_help.get_item_text(id)

	match item_name:
		"Documentation (online)":
			OS.shell_open("https://github.com/hiulit/Godot-Plugin-Particles-Renderer")
		"About":
			window_dialog_about.popup_centered_ratio(0.25)
