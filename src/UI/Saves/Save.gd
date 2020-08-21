#extends Control
#
#signal removed(index)
#signal save_created
#signal save_loaded
#
#onready var texture_button: TextureButton = $VBoxContainer/TextureButton
#onready var add_save: TextureRect = $VBoxContainer/TextureButton/AddSave
#onready var close: TextureButton = $Close
#onready var line_edit: LineEdit = $VBoxContainer/LineEdit
#
#
#var save: Dictionary = {
#	"name": "DEFAULT",
#	"dialog": "EMPTY",
#	"index": -1,
#	"thumbnail": ""
#}
#
#var has_save = false
#
#
#func _ready():
#	connect("save_created", self, "_on_save_created")
#
#	close.connect("pressed", self, "_on_close_pressed")
#	texture_button.connect("gui_input", self, "_on_input")
#
#	line_edit.connect("focus_entered", self, "_on_line_edit_focused")
#	line_edit.connect("focus_exited", self, "_release_focus")
#	line_edit.connect("text_entered", self, "_on_line_edit_entered")
#
#
#func _on_save_created():
#	ProgressManager.store_save(self.save)
#
#
#func _on_line_edit_focused():
#	line_edit.editable = true
#
#
#func _on_line_edit_entered(new_name):
#	update_save("name", new_name)
#	ProgressManager.update_save(self.save)
#	_release_focus()
#
#
#func _release_focus():
#	line_edit.editable = false
#	line_edit.release_focus()
#
#
#func _on_close_pressed():
#	var confirmed = yield(UI.ask_confirmation("Are you sure you want to delete this save?"), "answered")
#	if confirmed:
#		emit_signal("removed", self.save.index)
#		queue_free()
#
#
#func _on_input(event):
#	if event is InputEventMouseButton and event.pressed:
#		if event.doubleclick:
#			if not has_save:
#				create_save()
#			else:
#				load_save()
#			return
#
#		#print(str(self.save))
#
#
#func update_save(key: String, data):
#	self.save[key] = data
#
#	update_content()
#	self.has_save = true
#	close.visible = true
#	line_edit.visible = true
#	add_save.visible = false
#
#	self.has_save = (self.save.index > -1)
#
#
#func update_content():
#	self.line_edit.text = save.name
#	self.texture_button.texture_normal = UI.get_screenshot(save.thumbnail)
#
#
#func load_save():
#	self.save = ProgressManager.load_save(self.save.index)
#	emit_signal("save_loaded")
#
#
#func create_save():
#	update_save("thumbnail", UI.screenshot())
#	toggle_state()
#	emit_signal("save_created")
#
#
#func make_save(save_index):
#	update_save("name", "Save_%s" % str(save_index).pad_zeros(2))
#	update_save("dialog", ProgressManager.current_dialog)
#	update_save("thumbnail", UI.screenshot())
#	update_save("index", save_index)
#
#
#func made_save(save_index):
#	update_save("thumbnail", UI.get_screenshot(save.thumbnail))
#	update_save("index", save_index)
#
#
#
#func toggle_state():
#	close.visible = !close.visible
#	line_edit.visible = !line_edit.visible
#	add_save.visible = !add_save.visible
#
