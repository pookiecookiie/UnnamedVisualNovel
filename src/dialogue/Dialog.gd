extends Control

export(bool) var debug = false

const NARRATOR = "narrator"

onready var CharacterScene = preload("res://src/dialogue/characters/Chara.tscn")
onready var ChoiceScene = preload("res://src/dialogue/Choice.tscn")

onready var Background = $Background
onready var NameEdit = $Text/NameEdit
onready var Text = $Text/Box/Margin/Text
onready var DialogPlayer = $DialogPlayer
onready var DialogAnimator = $DialogAnimator
onready var CharactersContainer = $CharactersContainer
onready var Choices = $Text/Box/Margin/Choices

 

func _ready():
	DialogAnimator.connect("started", self, "_on_animator_started")
	DialogAnimator.connect("updated", self, "_on_animator_updated")
	DialogAnimator.connect("finished", self, "_on_animator_completed")
	
	DialogPlayer.connect("updated", self, "_on_dialog_updated")
	DialogPlayer.connect("finished", self, "_on_dialog_completed")
	
	var initial_dialog = Loader.get_dialog("choice_test")
	DialogPlayer.start(initial_dialog)
	


func _process(_delta):
	if Input.is_action_just_pressed("left_click"):
		if DialogAnimator.is_animating:
			DialogAnimator.skip_interpolation()
		else:
			DialogPlayer.next()


func _on_dialog_updated(dialog):
	if dialog.has("next"):
		var next_dialog = Loader.get_dialog(dialog.next)
		DialogPlayer.start(next_dialog)
	elif dialog.has("question"):
		handle_question(dialog)
	else:
		handle_conversation(dialog)
	

func _on_dialog_completed():
	pass



func _on_animator_started():
	$Text/DialogEndedIndicator.visible = !$Text/DialogEndedIndicator


func _on_animator_updated(_object, _key, _elapsed, value):
	Text.percent_visible = value


func _on_animator_completed():
	$Text/DialogEndedIndicator.visible = !$Text/DialogEndedIndicator


func handle_conversation(dialog):
	# Remove previous characters and Choices that might be still here
	clear_lists()
	
	# Character talking
	var speaker = Loader.get_character(dialog.name)
	var is_narrator = (dialog.name == NARRATOR)
	
	Text.add_font_override("normal_font", Loader.get_font(speaker.text_font))
	Text.add_color_override("default_color", speaker.text_color)
	NameEdit.add_font_override("font", Loader.get_font(speaker.name_font))
	NameEdit.add_color_override("font_color_uneditable", speaker.name_color)
	
	for character in dialog.characters:
		if not is_narrator:
			var sprite = Loader.get_character_sprite(character.name, character.emotion)
			var new_character = CharacterScene.instance()
			new_character.set_texture(sprite)
			CharactersContainer.add_child(new_character)
		
		
		
	Background.texture = Loader.get_background(dialog.background)
	NameEdit.text = speaker.display_name
	Text.bbcode_text = dialog.text
	
	# Starts the animation
	DialogAnimator.interpolate()


func handle_question(dialog):
	clear_lists()
	Text.hide()
	Choices.show()
	
	# Character talking
	var speaker = Loader.get_character(dialog.name)
	
	# Add choices
	for choice in dialog.choices:
		var choice_button = ChoiceScene.instance()
		choice_button.connect("pressed", self, "make_choice", [choice.choice])
		choice_button.text = choice.title
		Choices.add_child(choice_button)
	
	NameEdit.add_font_override("font", Loader.get_font(speaker.name_font))
	NameEdit.add_color_override("font_color_uneditable", speaker.name_color)
	
	NameEdit.text = dialog.title
	Background.texture = Loader.get_background(dialog.background)
	

func make_choice(choice):
	var next_scene = Loader.get_dialog(choice)
	Text.show()
	Choices.hide()
	DialogPlayer.reset()
	DialogAnimator.reset()
	DialogPlayer.start(next_scene)


func clear_lists():
	for choice in Choices.get_children():
		choice.queue_free()
	
	for character in CharactersContainer.get_children():
		character.queue_free()
	











