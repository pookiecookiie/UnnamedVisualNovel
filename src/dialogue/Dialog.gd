extends Control

export(bool) var debug = false

const NARRATOR = "narrator"

onready var CharacterScene = preload("res://src/dialogue/characters/Chara.tscn")
onready var ChoiceScene = preload("res://src/dialogue/Choice.tscn")

signal started_do()
signal finished_do()

onready var dialog_box = $Text
onready var Background = $Background
onready var NameEdit = $Text/NameEdit
onready var Text = $Text/Box/Margin/Text
onready var DialogAnimator = $DialogAnimator
onready var CharactersContainer = $CharactersContainer
onready var Choices = $Text/Box/Margin/Choices
onready var DialogPlayer = $DialogPlayer

 

func _ready():
	DialogAnimator.connect("started", self, "_on_animator_started")
	DialogAnimator.connect("updated", self, "_on_animator_updated")
	DialogAnimator.connect("finished", self, "_on_animator_completed")
	
	DialogPlayer.connect("started", self, "_on_dialog_started")
	DialogPlayer.connect("updated", self, "_on_dialog_updated")
	DialogPlayer.connect("finished", self, "_on_dialog_completed")
	
	UI.animation_player.play("fade_black")
	var dialog = ProgressManager.current_dialog
	var dialog_index = ProgressManager.dialog_index
	yield(SceneManager, "scene_changed")
	DialogPlayer.start(dialog, dialog_index)


func _process(_delta):
	if Input.is_action_just_pressed("left_click"):
		if DialogAnimator.is_animating:
			DialogAnimator.skip_interpolation()
		else:
			if not DialogPlayer.current.has("type"):
				DialogPlayer.next()
			elif not (DialogPlayer.current.type == "question" or "do"):
				DialogPlayer.next()


func _on_dialog_started():
	UI.animation_player.play_backwards("fade_black")
	Background.visible = true
	CharactersContainer.visible = true
	dialog_box.visible = true
	yield(UI.animation_player, "animation_finished")
	


func _on_dialog_updated(dialog):
	if dialog.has("type"):
		handle_dialog_type(dialog)
	else:
		handle_conversation(dialog)


func _on_dialog_completed():
	Background.visible = false
	CharactersContainer.visible = false
	dialog_box.visible = false


func _on_animator_started():
	$Text/DialogEndedIndicator.visible = !$Text/DialogEndedIndicator


func _on_animator_updated(_object, _key, _elapsed, value):
	Text.percent_visible = value


func _on_animator_completed():
	$Text/DialogEndedIndicator.visible = !$Text/DialogEndedIndicator


func handle_dialog_type(dialog):
	if dialog.type == "go_to":
		DialogPlayer.start(dialog.next)
	
	if dialog.type == "question":
		handle_question(dialog)
	
	if dialog.type == "do":
		handle_do(dialog)
	

func handle_conversation(dialog):
	# Remove previous characters and Choices that might be still here
	clear_lists()
	
	# Character talking
	var speaker = Loader.get_character(dialog.name)
	
	Text.add_font_override("normal_font", Loader.get_font(speaker.text_font))
	Text.add_color_override("default_color", speaker.text_color)
	NameEdit.add_font_override("font", Loader.get_font(speaker.name_font))
	NameEdit.add_color_override("font_color_uneditable", speaker.name_color)
	
	for character in dialog.characters:
		if not dialog.name == NARRATOR:
			var sprite = Loader.get_character_sprite(character.name, character.emotion)
			var new_character = CharacterScene.instance()
			new_character.set_texture(sprite)
			CharactersContainer.add_child(new_character)
	
	if dialog.name == NARRATOR:
		NameEdit.hide()
	else:
		NameEdit.show()
	
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
	
	for character in dialog.characters:
		if not character.name == NARRATOR:
			var sprite = Loader.get_character_sprite(character.name, character.emotion)
			var new_character = CharacterScene.instance()
			new_character.set_texture(sprite)
			CharactersContainer.add_child(new_character)
	
	# Hide it here, and show it when we make a choice
	NameEdit.hide()
	Background.texture = Loader.get_background(dialog.background)


func handle_do(dialog):
	if dialog.action == "animation":
		Background.visible = false
		CharactersContainer.visible = false
		dialog_box.visible = false
		# Weird animation glitch here, made backgroudn black to hide it
		UI.animation_player.play("fade_black")
		yield(UI.animation_player,"animation_finished")
		Background.texture = Loader.get_background(dialog.background)
		UI.animation_player.play(dialog.animation)
		yield(UI.animation_player,"animation_finished")
		Background.visible = true
		CharactersContainer.visible = true
		dialog_box.visible = true
		DialogPlayer.next()
		
	

func make_choice(choice):
	Text.show()
	Choices.hide()
	NameEdit.show()
	
	if choice.empty():
		DialogPlayer.next()
		return
	
	DialogPlayer.reset()
	DialogAnimator.reset()
	
	var next_scene = Loader.get_dialog(choice)
	DialogPlayer.start(next_scene)


func clear_lists():
	for choice in Choices.get_children():
		choice.queue_free()
	
	for character in CharactersContainer.get_children():
		character.queue_free()
	











