extends Control

export(Texture) var texture: Texture

signal save_created
signal save_loaded

onready var texture_button: TextureButton = $VBoxContainer/TextureButton
onready var add_save: TextureRect = $VBoxContainer/TextureButton/AddSave
onready var close: TextureButton = $Close
onready var line_edit: LineEdit = $VBoxContainer/LineEdit


var save_name: String = ""
var has_save = false


func _ready():
	texture_button.connect("gui_input", self, "_on_input")
	close.connect("pressed", self, "_on_close_pressed")
	line_edit.connect("focus_entered", self, "_on_line_edit_focused")
	line_edit.connect("text_entered", self, "_on_line_edit_entered")

func _on_line_edit_focused():
	line_edit.editable = true

func _on_line_edit_entered(text):
	save_name = text
	line_edit.editable = false
	line_edit.release_focus()


func _on_close_pressed():
	var confirmed = yield(UI.ask_confirmation("Are you sure you want to delete this save?"), "answered")
	if confirmed:
		queue_free()


func _on_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.doubleclick:
			print(self.name)
			if not has_save:
				create_save()
			else:
				load_save()


func load_save():
	emit_signal("save_loaded")


func create_save():
	# Get Dialog Scene viewport
	var img = get_viewport().get_texture().get_data()
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	img.flip_y()
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	
	texture_button.texture_normal = tex
	
	self.has_save = true
	close.visible = true
	line_edit.visible = true
	add_save.visible = false
	emit_signal("save_created")
