extends Control

var app_name := "Particles Renderer"
var app_version := "0.1.0"
var contiguous_frames := false
var initial_fps: int
var keep_proportions := true
var fps: int
var max_frames := 0
var output_path: String
var particles_node
var render_with_scaling := false
var rendering := false
var skip_frame := 1
var sprite_sheet_file_name: String
var sprite_sheets_counter := 0
var sprite_size := Vector2(32, 32) setget _set_sprite_size
var sprites_counter := 0
var time: float
var timer := 0.0
var tmp_path := "user://particles_renderer_tmp"
var window_size := Vector2(800, 600)

var about_string := (
	"[center]"
	+ "[u][b]%app_name[/b][/u]"
	+ "\n\n"
	+ "[table=2]"
	+ "[cell][right]Version: [/right][/cell]"
	+ "[cell][right]%app_version[/right][/cell]"
	+ "[cell][right]License: [/right][/cell]"
	+ "[cell][right]MIT[/right][/cell]"
	+ "[cell][right]Author: [/right][/cell]"
	+ "[cell][right]hiulit[/right][/cell]"
	+ "[/table]"
	+ "[/center]"
)

onready var about_text := $MenuBar/WindowDialogAbout/RichTextLabel
onready var actual_input_size_x := $ScaleContainer/VBoxActualSizeContainer/HBoxContainer/InputSizeX
onready var actual_input_size_y := $ScaleContainer/VBoxActualSizeContainer/HBoxContainer/InputSizeY
onready var base_input_size_x := $InputSizeContainer/HBoxContainer/VBoxContainerBaseSpriteSize/HBoxContainer/InputSizeX
onready var base_input_size_y := $InputSizeContainer/HBoxContainer/VBoxContainerBaseSpriteSize/HBoxContainer/InputSizeY
onready var choose_path_file_dialog := $BottomBar/ChoosePathFileDialog
onready var draw := $Draw
onready var emit_button := $ButtonsContainer/HBoxContainer/EmitButton
onready var emit_stop_button := $ButtonsContainer/HBoxContainer/EmitStopButton
onready var error_dialog := $ErrorContainer/WindowDialog
onready var error_text := $ErrorContainer/WindowDialog/RichTextLabel
onready var file_name_line_edit := $BottomBar/VBoxContainer/HBoxContainer/HBoxContainerFileName/FileNameLineEdit
onready var input_fps := $InputSizeContainer/HBoxContainer/VBoxContainerFPS/HBoxContainer/FPS
onready var input_max_frames := $InputSizeContainer/HBoxContainer/VBoxContainerMaxFrames/HBoxContainer/MaxFrames
onready var input_time := $InputSizeContainer/HBoxContainer/VBoxContainerTime/HBoxContainer/Time
onready var keep_proportions_checkbox := $InputSizeContainer/HBoxContainer/VBoxContainerBaseSpriteSize/HBoxContainer/ProportionCheckBox
onready var output_path_line_edit := $BottomBar/VBoxContainer/HBoxContainer/HBoxContainerOutputPath/LineEdit
onready var overlay := $Overlay
onready var render_button := $ButtonsContainer/HBoxContainer/RenderButton
onready var render_checkbox := $ButtonsContainer/HBoxContainer/RenderCheckBox
onready var scale_number := $ScaleContainer/VBoxSliderContainer/HBoxContainer/ScaleNumber
onready var scale_slider := $ScaleContainer/ScaleSlider
onready var target_viewport := $ViewportContainer/Viewport
onready var time_progress := $Overlay/TimeProgress/TextureProgress
onready var viewport_container := $ViewportContainer


func _ready() -> void:
	set_process(false)

	create_directory(tmp_path)

	get_tree().set_screen_stretch(
		SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, window_size
	)

	OS.set_window_title(app_name)
	OS.set_min_window_size(window_size)
	OS.set_window_size(window_size)

	initial_fps = Engine.get_target_fps()
	fps = int(input_fps.text)
	Engine.set_target_fps(fps)

	time = float(input_time.text)

	disable_buttons()

	self.sprite_size = sprite_size

	target_viewport.transparent_bg = true
	target_viewport.usage = Viewport.USAGE_2D

	base_input_size_x.text = str(sprite_size.x)
	base_input_size_y.text = str(sprite_size.y)

	scale_slider.value = 1.0

	about_string = about_string.replace("%app_name", app_name)
	about_string = about_string.replace("%app_version", app_version)
	about_text.bbcode_text = about_string

	time_progress.step = 0.01


func _process(delta: float) -> void:
	timer += delta

	time_progress.value = timer

	if timer > time or "emitting" in particles_node and not particles_node.emitting:
		timer = 0
		rendering = false

	generate_sprite()

	if not rendering:
		overlay.visible = false
		set_process(false)
		generate_sprite_sheet()


func disable_buttons() -> void:
	emit_button.disabled = true
	emit_stop_button.disabled = true
	render_button.disabled = true
	render_checkbox.disabled = true
	render_checkbox.pressed = false


func enable_buttons() -> void:
	if "emitting" in particles_node:
		emit_button.disabled = false

		if "one_shot" in particles_node and not particles_node.one_shot:
			emit_stop_button.disabled = false

	render_button.disabled = false
	render_checkbox.disabled = false
	render_checkbox.pressed = true


func set_viewport_size(size: Vector2) -> void:
	viewport_container.rect_position = Vector2(
		(window_size.x / 2.0) - (size.x / 2.0), (window_size.y / 2.0) - (size.y / 2.0)
	)
	viewport_container.rect_size = size

	target_viewport.size = size

	actual_input_size_x.text = str(size.x)
	actual_input_size_y.text = str(size.y)

	if particles_node:
		particles_node.position = size / 2.0
		particles_node.scale = Vector2.ONE * scale_slider.value

	draw.rect = Rect2(viewport_container.rect_position, viewport_container.rect_size)


func create_directory(path: String) -> void:
	var dir = Directory.new()
	dir.make_dir(path)


func delete_sprites(path: String) -> void:
	var dir = Directory.new()

	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)

		var file = dir.get_next()

		while file != "":
			dir.remove(file)
			file = dir.get_next()

		dir.list_dir_end()
	else:
		show_error("Can't access '%s'." % path)


func generate_sprite() -> void:
	var image = target_viewport.get_texture().get_data()

	if image.is_invisible():
		sprites_counter -= 1
		return

	var image_path = tmp_path.plus_file("%0*d.png") % [2, sprites_counter]

	image.flip_y()
	image.save_png(image_path)

	sprites_counter += 1


func generate_sprite_sheet() -> void:
	var image := Image.new()
	var image_size := Vector2(sprites_counter * sprite_size.x, sprite_size.y)

	if max_frames > 0:
		image_size.x = max_frames * sprite_size.x

		if contiguous_frames:
			skip_frame = 1
			sprites_counter = max_frames
		else:
			skip_frame = ceil(sprites_counter / float(max_frames))

	image.create(image_size.x, image_size.y, false, Image.FORMAT_RGBA8)

	var pointer := 0

	for i in range(0, sprites_counter, skip_frame):
		var blit_image := Image.new()

		blit_image.load(tmp_path.plus_file("%0*d.png") % [2, i])

		image.blit_rect(
			blit_image,
			Rect2(0, 0, sprite_size.x, sprite_size.y),
			Vector2(pointer * sprite_size.x, 0)
		)

		pointer += 1

	var image_path := (
		output_path.plus_file(sprite_sheet_file_name + "_%0*d.png")
		% [2, sprite_sheets_counter]
	)

	image.save_png(image_path)

	delete_sprites(tmp_path)

	load_preview_texture(image_path)

	sprite_sheets_counter += 1
	sprites_counter = 0


func load_preview_texture(image_path) -> void:
	OS.shell_open(str("file://") + ProjectSettings.globalize_path(image_path))


func show_error(message: String, size := Vector2(300, 50)):
	error_text.text = message
	error_dialog.popup_centered(size)


func sprite_sheet_too_large():
	var sprite_sheet_width: int
	var calculation_string: String

	if max_frames == 0:
		sprite_sheet_width = fps * time * sprite_size.x
		calculation_string = (
			"'FPS' (%s) * 'Time' (%s) * 'Base sprite size X' (%s)" % [fps, time, sprite_size.x]
		)
	else:
		sprite_sheet_width = max_frames * sprite_size.x
		calculation_string = (
			"'Max frames' (%s) * 'Base sprite size X' (%s)" % [max_frames, sprite_size.x]
		)

	if sprite_sheet_width > 16384:
		show_error(
			"The sprite sheet image's width ("
			+ calculation_string + " = "
			+ str(sprite_sheet_width) + "px) "
			+ "cannot be greater than 16384px."
			+ "\n\n"
			+ "Try setting 'Max frames' or lowering 'FPS' or 'Time' "
			+ "to decrease the sprite sheet image's width.",
			Vector2(500, 100)
		)
		return true


func _on_EmitButton_pressed() -> void:
	particles_node.emitting = true


func _on_EmitStopButton_pressed() -> void:
	particles_node.emitting = false


func _on_RenderButton_pressed() -> void:
	if not output_path:
		show_error("An output path must be provided.")
		return

	if not sprite_sheet_file_name:
		show_error("A file name must be provided.")
		return

	if sprite_size.x == 0 or sprite_size.y == 0:
		show_error("The X and Y values of 'Base sprite size' must be both greater than '0'.")
		return

	if sprite_sheet_too_large():
		return

	if render_with_scaling:
		self.sprite_size = Vector2(int(actual_input_size_x.text), int(actual_input_size_y.text))
		particles_node.scale = Vector2.ONE * scale_slider.value
	else:
		self.sprite_size = Vector2(int(base_input_size_x.text), int(base_input_size_y.text))
		particles_node.scale = Vector2.ONE

	overlay.visible = true
	time_progress.max_value = time - 0.05
	time_progress.value = 0
	rendering = true
	set_process(true)

	if "emitting" in particles_node:
		if not particles_node.emitting:
			particles_node.emitting = true


func _on_RenderCheckBox_toggled(button_pressed):
	render_with_scaling = button_pressed

	if render_with_scaling:
		scale_slider.editable = true

		self.sprite_size = Vector2(
			float(base_input_size_x.text) * scale_slider.value,
			float(base_input_size_y.text) * scale_slider.value
		)
	else:
		scale_slider.editable = false

		self.sprite_size = Vector2(float(base_input_size_x.text), float(base_input_size_y.text))


func _on_OpenFileFileDialog_file_selected(path: String) -> void:
	if not output_path:
		output_path_line_edit.text = path.get_base_dir()
		output_path = output_path_line_edit.text

	if not sprite_sheet_file_name:
		file_name_line_edit.text = path.get_file().replace('.' + path.get_extension(), '')
		sprite_sheet_file_name = file_name_line_edit.text

	sprite_sheets_counter = 0

	particles_node = load(path).instance()
	particles_node.position = target_viewport.size / 2.0
	particles_node.scale = Vector2.ONE * scale_slider.value

	target_viewport.add_child(particles_node)

	enable_buttons()


func _on_ChoosePathFileDialog_dir_selected(dir: String) -> void:
	output_path = dir
	output_path_line_edit.text = output_path

	sprite_sheets_counter = 0


func _on_ScaleSlider_value_changed(value: float) -> void:
	scale_number.text = str(value)

	self.sprite_size = Vector2(
		float(base_input_size_x.text) * value, float(base_input_size_y.text) * value
	)


func _on_InputSizeX_text_changed(new_text: String) -> void:
	self.sprite_size.x = int(new_text) * int(scale_number.text)

	if keep_proportions:
		self.sprite_size.y = sprite_size.x
		base_input_size_y.text = new_text


func _on_InputSizeY_text_changed(new_text: String) -> void:
	self.sprite_size.y = int(new_text) * int(scale_number.text)

	if keep_proportions:
		self.sprite_size.x = sprite_size.y
		base_input_size_x.text = new_text


func _on_ProportionCheckBox_toggled(button_pressed: bool) -> void:
	keep_proportions = button_pressed


func _on_MaxFrames_text_changed(new_text: String) -> void:
	max_frames = int(new_text)

	if max_frames > fps:
		show_error("Max frames cannot be greater than FPS.")
		max_frames = fps
		input_max_frames.text = str(max_frames)



func _on_ContiguousMaxFramesCheckBox_toggled(button_pressed: bool) -> void:
	contiguous_frames = button_pressed


func _on_FPS_text_changed(new_text: String) -> void:
	fps = int(new_text)
	Engine.set_target_fps(fps)


func _on_Time_text_changed(new_text: String) -> void:
	time = float(new_text)


func _on_ChoosePathButton_pressed() -> void:
	choose_path_file_dialog.popup_centered_ratio(0.5)


func _on_FileNameLineEdit_text_changed(new_text: String) -> void:
	sprite_sheet_file_name = new_text
	sprite_sheets_counter = 0


func _on_ParticlesRendererWindow_tree_exited():
	Engine.set_target_fps(initial_fps)


func _set_sprite_size(new_value):
	sprite_size = new_value
	set_viewport_size(sprite_size)
