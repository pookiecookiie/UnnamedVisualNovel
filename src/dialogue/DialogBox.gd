extends Control

export(bool) var debug = false

onready var Background = $Background
onready var TextEditor = $Text/Box/Margin/TextEditor
onready var NameEdit = $Text/NameEdit
onready var Text = $Text/Box/Margin/Text
onready var DialogPlayer = $DialogPlayer
onready var PropsContainer = $PropsContainer


# Debug
signal error(message, from)
signal warn(message, from)
signal info(message, from)
signal success(message, from)
 
var started = false
func _ready():
	connect("error", Debug, "_on_error")
	connect("warn", Debug, "_on_warn")
	connect("info", Debug, "_on_info")
	connect("success", Debug, "_on_success")
	if not started:
		started = true
		DialogPlayer.start(Loader.get_dialog("introduction"))

func _input(event):
	if Input.is_mouse_button_pressed(1):
		DialogPlayer.next()
	
	update_content(DialogPlayer)
	


func update_content(content):
	for child in PropsContainer.get_children():
		child.queue_free()
	
	var background = Loader.get_background(content.background)
	Background.texture = background
	TextEditor.text = content.text # Interpolate this later
	Text.text = content.text # Interpolate?
	NameEdit.text = content.title
	
	for character in content.characters:
		var chara = load("res://src/dialogue/characters/Chara.tscn").instance()
		var chara_texture = Loader.get_character(character.name, character.emotion)
		chara.set_texture(chara_texture)
		PropsContainer.add_child(chara)
	
	











