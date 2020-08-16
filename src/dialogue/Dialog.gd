extends Control

export(bool) var debug = false

onready var ChoiceScene = preload("res://src/dialogue/Choice.tscn")

onready var Background = $Background
onready var NameEdit = $Text/NameEdit
onready var Text = $Text/Box/Margin/Text
onready var DialogPlayer = $DialogPlayer
onready var DialogAnimator = $DialogAnimator
onready var CharactersContainer = $CharactersContainer
onready var PropsContainer = $PropsContainer
onready var Choices = $Text/Box/Margin/Choices


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
	
	DialogPlayer.connect("finished", self, "_on_end_dialog")
	
	DialogPlayer.start(Loader.get_dialog("choose_a_ramification"))
	update_content(DialogPlayer)


func _process(delta):
	$Text/DialogEndedIndicator.visible = not DialogAnimator.is_animating
	if DialogPlayer.current_line.has("type"):
		$Text/DialogEndedIndicator.visible = false
	
	if Input.is_action_just_pressed("left_click"):
		if DialogAnimator.is_animating:
			DialogAnimator.end_interpolation_animation()
		else:
			DialogAnimator.end_interpolation()
			if DialogPlayer.next():
				update_content(DialogPlayer)


func _on_step_dialog(percent_visible):
	Text.percent_visible = percent_visible


func _on_end_dialog(next):
	if not next.empty():
		DialogPlayer.start(Loader.get_dialog(next))


func update_content(content):
	clear_content()
	CharactersContainer.show()
	PropsContainer.show()
	
	var background = Loader.get_background(content.background)
	Background.texture = background
	
	var character = Loader.get_character(content.char_name)
	Text.add_font_override("normal_font", Loader.get_font(character.text_font))
	Text.add_color_override("default_color", character.text_color)
	
	NameEdit.add_font_override("font", Loader.get_font(character.name_font))
	NameEdit.add_color_override("font_color_uneditable", character.name_color)
	
	
	if content.current_line.has("type"): # is a question
		Text.hide()
		Choices.show()
		NameEdit.text = content.title
		for choice in content.choices:
			var choice_button = ChoiceScene.instance()
			choice_button.connect("pressed", self, "make_choice", [choice.ramification])
			choice_button.text = choice.title
			Choices.add_child(choice_button)
		return
	
	NameEdit.text = content.char_name
	Text.bbcode_text = content.text
	DialogAnimator.set_interpolation_speed(content.text_speed)
	DialogAnimator.start_interpolation()
	
	
	for _character in content.characters:
		if _character.emotion:
			var chara = load("res://src/dialogue/characters/Chara.tscn").instance()
			var chara_texture = Loader.get_character(_character.name, _character.emotion)
			chara.set_texture(chara_texture)
			CharactersContainer.add_child(chara)


func make_choice(choice):
	var next_scene = Loader.get_dialog(choice)
	DialogPlayer.reset()
	DialogPlayer.start(next_scene)
	update_content(DialogPlayer)


func clear_content():
	Text.show()
	Choices.hide()
	
	Text.bbcode_text = ""
	NameEdit.text = ""
	
	for prop in PropsContainer.get_children():
		prop.queue_free()
	
	for chara in CharactersContainer.get_children():
		chara.queue_free()
	
	for choice in Choices.get_children():
		choice.queue_free()

func clear():
	CharactersContainer.hide()
	PropsContainer.hide()
	
	for prop in PropsContainer.get_children():
		prop.queue_free()
	
	for chara in CharactersContainer.get_children():
		chara.queue_free()
	











