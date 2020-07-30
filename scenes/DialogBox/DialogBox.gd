extends Control


onready var TextEditor = $Text/Box/Margin/TextEditor
onready var Text = $Text/Box/Margin/Text
onready var NameEdit = $Text/NameEdit

export(bool) var debug : bool = true

var editing : bool = false
var is_playing : bool = false

var dialog_speed : float = 1
var lines : Array = []


signal finished_dialog_animation

# Debug
signal error(message, from)
signal warn(message, from)
signal info(message, from)
signal success(message, from)
 

# Called when the node enters the scene tree for the first time.
func _ready():
	# Debug
	connect("error", Debug, "_on_error")
	connect("warn", Debug, "_on_warn")
	connect("info", Debug, "_on_info")
	connect("success", Debug, "_on_success")
	
	connect("finished_dialog_animation", self, "_on_dialog_animation_finish")
	
	update_editing_mode()
	load_dialog()


func _process(delta):
	if is_playing:
		step_dialog_animation(delta)


func _input(event:InputEvent):
	if event.is_action_pressed("middle_click"):
		toggle_editing_mode()
	
	if event.is_action_pressed("enter"):
		play_dialog()

func _on_dialog_animation_finished():
	print("Finished Dialog")


func update_dialog(dialog:Dictionary):
	NameEdit.text = dialog.name
	TextEditor.text = dialog.text
	Text.text = dialog.text


func save_dialog():
	var dialog_to_save = {
		"name": NameEdit.text,
		"text": TextEditor.text
	}
	
	Cache.store("dialogX", dialog_to_save)


func load_dialog():
	var dialog_to_save = {
		"name": Cache.cache.dialogX.name,
		"text": Cache.cache.dialogX.text
	}
	update_dialog(dialog_to_save)


func step_dialog_animation(delta):
	if Text.percent_visible < 1:
		Text.percent_visible += (dialog_speed) * delta
	else:
		is_playing = false
		emit_signal("finished_dialog_animation")


func play_dialog():
	# Cannot play the dialog when editing
	self.editing = false
	update_editing_mode()
	
	is_playing = true


func update_editing_mode():
	TextEditor.visible = self.editing
	Text.visible = !self.editing
	NameEdit.editable = self.editing


func toggle_editing_mode():
	self.editing = !self.editing
	update_editing_mode()
	
	emit_signal("info", "Editting: " + str(self.editing), self.name)

