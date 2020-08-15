extends Control

export(bool) var debug = false

onready var Background = $Background
onready var NameEdit = $Text/NameEdit
onready var Text = $Text/Box/Margin/Text
onready var DialogPlayer = $DialogPlayer
onready var DialogAnimator = $DialogAnimator
onready var PropsContainer = $PropsContainer


# Debug
signal error(message, from)
signal warn(message, from)
signal info(message, from)
signal success(message, from)
 

func _ready():
	connect("error", Debug, "_on_error")
	connect("warn", Debug, "_on_warn")
	connect("info", Debug, "_on_info")
	connect("success", Debug, "_on_success")
	
	DialogAnimator.connect("step_dialog_animation", self, "_on_step_dialog")
	DialogAnimator.connect("end_dialog_animation", self, "_on_end_dialog")
	
	DialogPlayer.start(Loader.get_dialog("introduction"))
	update_content(DialogPlayer)


func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		if DialogAnimator.is_animating:
			DialogAnimator.end_interpolation_animation()
		else:
			DialogAnimator.end_interpolation()
			DialogPlayer.next()
			update_content(DialogPlayer)


func _on_step_dialog(percent_visible):
	Text.percent_visible = percent_visible


func _on_end_dialog():
	pass


func update_content(content):
	for child in PropsContainer.get_children():
		child.queue_free()
	
	var background = Loader.get_background(content.background)
	Background.texture = background
	#TextEditor.text = content.text # Interpolate this later
	Text.add_font_override("normal_font", Loader.get_font("raleway"))
	
	Text.bbcode_text = content.text
	DialogAnimator.set_interpolation_speed(content.text_speed)
	DialogAnimator.start_interpolation()
	
	
	NameEdit.add_font_override("font", Loader.get_font("raleway"))
	NameEdit.add_color_override("font_color_uneditable", Loader.get_character(content.title).color)
	NameEdit.text = content.title
	
	for character in content.characters:
		var chara = load("res://src/dialogue/characters/Chara.tscn").instance()
		var chara_texture = Loader.get_character(character.name, character.emotion)
		chara.set_texture(chara_texture)
		PropsContainer.add_child(chara)
	
	











