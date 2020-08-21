extends Control


onready var button: TextureButton = $VBoxContainer/TextureButton
onready var add_save: TextureRect = $VBoxContainer/TextureButton/AddSave
onready var delete_button: TextureButton = $VBoxContainer/TextureButton/Delete
onready var line_edit: LineEdit = $VBoxContainer/LineEdit


signal pressed(btn)
signal updated(btn) # Do i need this?
signal deleted(btn)

var save: Dictionary = {}

func _ready():
	button.connect("pressed", self, "_on_button_pressed")
	button.connect("mouse_entered", self, "_on_button_mouse_entered")
	delete_button.connect("pressed", self, "_on_delete_pressed")
	line_edit.connect("focus_entered", self, "_on_focus_entered")
	line_edit.connect("focus_exited", self, "_on_focus_exited")
	line_edit.connect("text_entered", self, "_on_name_entered")


func _on_button_pressed():
	if save.empty():
		emit_signal("pressed", self)
	else:
		SceneManager.send_arguments([self.save.dialog])
		SceneManager.change_scene(SceneManager.Dialog, "fade_black")


func _on_button_mouse_entered():
	print("%s's save is: %s" % [self.name, self.save])


func _on_delete_pressed():
	print("Deleting... %s" % self.name)
	emit_signal("deleted", self)


func _on_focus_entered():
	line_edit.editable = true


func _on_focus_exited():
	line_edit.editable = false


func _on_name_entered(new_name):
	self.save.name = new_name
	update_info()
	line_edit.editable = false
	line_edit.release_focus()


func set_save(save:Dictionary={}):
	self.save = save
	self.name = self.save.name


func show_info():
	add_save.visible = false
	line_edit.visible = true
	delete_button.visible = true
	
	line_edit.editable = true
	line_edit.grab_focus()
	line_edit.caret_position = line_edit.text.length()


func update_info():
	line_edit.text = save.name
	
	if not save.thumbnail.empty():
		button.texturenormal = UI.get_screenshot(save.thumbnail)


func delete():
	queue_free()


