extends HBoxContainer


onready var save_button_scene = load("res://tests/Save.tscn")

var saves: Dictionary = {}

func _ready():
	#saves = SaveManager.get_saves()
	
	if saves.empty():
		var first_button = create_save_button({})
		# Adding it manually because i dont want this one to be considered a "save"
		add_child(first_button)
		return
	else:
		for save in saves:
			var save_button = create_save_button(saves[save])
			add_button(save_button)
		organize_children()


func _exit_tree():
	pass


func _on_save_button_pressed(which_button_pressed):
	# This button was empty, but now has a save
	var new_save = create_save()
	which_button_pressed.set_save(new_save)
	which_button_pressed.update_info()
	which_button_pressed.show_info()
	
	var button_save = which_button_pressed.save
	set_save(button_save.name, button_save)
	
	# Create a new button
	var new_button = create_save_button({})
	add_child(new_button)
	organize_children()


func _on_save_button_deleted(which_button_deleted):
	remove_button(which_button_deleted)


# Create an empty save button
# OR creates a button AND sets its save
func create_save_button(save):
	var save_button = save_button_scene.instance()
	
	if not save.empty():
		# Set the button save "save"
		save_button.set_save(save)
	
	save_button.connect("pressed", self, "_on_save_button_pressed")
	save_button.connect("updated", self, "_on_save_button_updated")
	save_button.connect("deleted", self, "_on_save_button_deleted")
	return save_button


func create_save():
	
	var saves_buffer = self.saves.keys()
	saves_buffer.invert()
	var next_name = "Save_%s" % str(self.saves.size()+1)
	for save in saves_buffer:
		if save == next_name:
			# This is repeated name
			next_name = "Save_%s" % str(self.saves.size()+2)
	
	var new_save = {
		"name": next_name,
		"dialog": "introduction",
		"thumbnail": ""
	}

	return new_save


func add_button(button):
	add_child(button)
	set_save(button.save.name, button.save)


func remove_button(button):
	remove_child(button)
	erase_save(button.save.name)
	button.delete()


func erase_save(key: String):
	self.saves.erase(key)


func set_save(key: String, data):
	self.saves[key] = data


func organize_children():
	var children = get_children()
	var last_child = children[children.size()-1]
	move_child(last_child, 0)


