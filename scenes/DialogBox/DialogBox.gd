extends Control


onready var Text = $Text/Box/Margin/Text
onready var NameEdit = $Text/NameEdit

export(bool) var debug : bool = true

var editing : bool = false

#WIP
var dialog_index : int = 0


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
	
	update_editing_mode()
	load_dialog()
	


func _input(event:InputEvent):
	if event.is_action_pressed("middle_click"):
		toggle_editing_mode()
	
	if event.is_action_pressed("enter"):
		save_dialog()


func update_dialog(dialog:Dictionary):
	NameEdit.text = dialog.name
	Text.text = dialog.text


func save_dialog():
	var dialog_to_save = {
		"name": NameEdit.text,
		"text": Text.text
	}
	
	Cache.store("dialogX", dialog_to_save)


func load_dialog():
	var dialog_to_save = {
		"name": Cache.cache.dialogX.name,
		"text": Cache.cache.dialogX.text
	}
	update_dialog(dialog_to_save)


func update_editing_mode():
	Text.readonly = !self.editing
	NameEdit.editable = self.editing


func toggle_editing_mode():
	self.editing = !self.editing
	update_editing_mode()
	emit_signal("info", "Editting: " +str(self.editing), self.name)

